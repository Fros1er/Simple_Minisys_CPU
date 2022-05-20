`timescale 1ns / 1ps

module cpu_top(
    input sys_clk, rst_in, start_pg,
    input rx,
    output start_pg_led, tx,
    inout[15:0] gpio_a_out, gpio_b_out, gpio_c_out, 
    inout[13:0] gpio_d_out, 
    inout[7:0] gpio_e_out
//    , gpio_f_out
);
//    reg sys_clk, rst_in, start_pg;

    assign start_pg_led = start_pg;
    
    wire rst, clk, nvic_clk, uart_clk, systick_clk, rd_write_enable, rt_write_enable, alu_en, mem_write_en, 
        io_write_en, is_sw, is_io_target, is_usage_fault, curr_gpio_type;
    wire [1:0] alu_type;
    wire[4:0] rd, rs, rt, shamt;
    wire[5:0] funct, opcode, gpio_types, exti_enable;
    wire[9:0] io_access_target;
    wire[15:0] immediate, io_read_val, exti_io_read_val, gpio_a, gpio_b, gpio_c, gpio_d, gpio_e, gpio_f;
    wire[31:0] rs_val, rt_val, reg_write_val;
    wire[31:0] result;
    wire[31:0] mem_access_target, mem_write_val, mem_io_read_val, mem_read_val;
    wire[31:0] return_addr;
    
    reg[8:0] pending_interrupts;
    reg[15:0] gpio_in_buffers[5:0];
    reg uart_rst;
    
    wire spg_bufg, uart_clk_o, uart_write_en, uart_done, program_off;
    wire [14:0] uart_addr;
    wire [31:0] uart_data;

    assign rst = rst_in | !uart_rst;
    assign program_off = uart_rst | (~uart_rst & uart_done);
    
    assign reg_write_val = (opcode == 6'b10_0011) ? mem_io_read_val : 
                          (opcode == 6'b00_0011) ? return_addr : result;
    assign rd_write_enable = ((alu_en && alu_type == 2'b01 && funct[5:2] != 4'b1101) || opcode == 6'b00_0011);
    assign rt_write_enable = (alu_en && alu_type == 2'b0 && opcode != 6'b00_0100 && opcode != 6'b00_0101 && opcode != 6'b10_1011);
    
    assign is_sw = (opcode == 6'b10_1011);
    assign is_io_target = (mem_access_target[31:10] == 22'b1111_1111_1111_1111_1111_11);
    assign io_write_en = is_sw && is_io_target;
    assign mem_write_en = is_sw && !is_io_target;
    assign mem_write_val = rt_val;
    assign mem_access_target = rs_val + {{16{immediate[15]}}, immediate};
    assign io_access_target = mem_access_target[9:0];
    assign exti_io_read_val = curr_gpio_type ? io_read_val : // 加上exti后的io
                              (io_access_target[5:2] == 4'b0000) ? gpio_a_out :
                              (io_access_target[5:2] == 4'b0001) ? gpio_b_out :
                              (io_access_target[5:2] == 4'b0010) ? gpio_c_out :
                              (io_access_target[5:2] == 4'b0011) ? gpio_d_out :
                              (io_access_target[5:2] == 4'b0100) ? gpio_e_out : 0;
//                              (io_access_target[5:2] == 4'b0101) ? gpio_f_out : 0;
    assign mem_io_read_val = is_io_target ? exti_io_read_val : mem_read_val;

    assign gpio_a_out = gpio_types[0] ? gpio_a : 16'bz;
    assign gpio_b_out = gpio_types[1] ? gpio_b : 16'bz;
    assign gpio_c_out = gpio_types[2] ? gpio_c : 16'bz;
    assign gpio_d_out = gpio_types[3] ? gpio_d : 16'bz;
    assign gpio_e_out = gpio_types[4] ? gpio_e : 16'bz;
//    assign gpio_f_out = gpio_types[5] ? gpio_f : 16'bz;
    
    // cpuclk clk_d(
    //     .sys_clk(sys_clk),
    //     .clk(clk),
    //     .uart_clk(uart_clk),
    //     .nvic_clk(nvic_clk)
    // );
    
    // wire clk_t;
    // clock_div #(.period(100), .width(7)) cda(uart_clk, rst, clk_t);
    // clock_div #(.period(100), .width(7)) cd(clk_t, rst, systick_clk);
    
//    assign nvic_clk = sys_clk;
   clock_div #(.period(5), .width(4)) cd_a(sys_clk, rst, nvic_clk);
   clock_div #(.period(2), .width(3)) cd_b(nvic_clk, rst, clk);
   clock_div #(.period(10), .width(5)) cd_c(sys_clk, rst, uart_clk);
   systick_generator systick_gen(clk, rst, systick_clk);
    
//     wire need_jump, is_eret;
//     wire[31:0] tgt, epc0, instruction_sim, pc;
//     wire[8:0] int_en, arr;
//     wire[3:0] curr,next;
    ifetch i_fetch(
       .nvic_clk(nvic_clk),
       .clk(clk),
       .rst(rst),
       .result(result),
       .pending_interrupts(pending_interrupts),
       .is_usage_fault(is_usage_fault),
       .alu_en(alu_en),
       .alu_type(alu_type), // 1 R 0 I
       .return_addr(return_addr),
       .rs(rs),
       .rt(rt),
       .rd(rd),
       .immediate(immediate),
       .shamt(shamt),
       .funct(funct),
       .opcode(opcode),
       .program_off(program_off),
      .uart_clk(uart_clk_o),
      .uart_write_en(uart_write_en & !uart_addr[13]), 
      .uart_addr(uart_addr),
      .uart_data(uart_data)
//        ,.pc_sim(pc),.instruction(instruction_sim),.need_exception_jump(need_jump),.target_addr(tgt),.int_en(int_en),.arr(arr),.curr(curr),.next(next),.is_eret(is_eret),.epc0(epc0)
    );

    registers regs(
       .clk(clk),
       .rst(rst),
       .rs(rs),
       .rt(rt),
       .rd(rd),
       .rd_write_enable(rd_write_enable),
       .rt_write_enable(rt_write_enable),
       .write_val(reg_write_val),
       .rs_val(rs_val),
       .rt_val(rt_val)
    );

    alu alu_a(
       .alu_en(alu_en),
       .alu_type(alu_type), // 1 for R, 0 for I
       .opcode(opcode),
       .funct(funct),
       .rt(rt),
       .rs_val(rs_val),
       .rt_val(rt_val),
       .shamt(shamt),
       .immediate(immediate),
       .result(result),
       .is_fault(is_usage_fault)
    );

    memory mem(
       .clk(clk),
       .rst(rst),
       .write_en(mem_write_en),
       .write_val(mem_write_val),
       .access_target(mem_access_target),
       .read_val(mem_read_val),
       .program_off(program_off),
       .uart_clk(uart_clk_o),
       .uart_write_en(uart_write_en & uart_addr[13]), 
       .uart_addr(uart_addr),
       .uart_data(uart_data)
    );
    
    io io_a(
       .clk(clk),
       .rst(rst),
       .write_en(io_write_en),
       .access_target(io_access_target),
       .write_val(mem_write_val),
       .buffer_read_val(io_read_val),
       .gpio_a(gpio_a),
       .gpio_b(gpio_b),
       .gpio_c(gpio_c),
       .gpio_d(gpio_d),
       .gpio_e(gpio_e),
       .gpio_f(gpio_f),
       .curr_gpio_type(curr_gpio_type),
       .gpio_types(gpio_types),
       .exti_enable(exti_enable)
    );
    
    
    BUFG U1(.I(start_pg), .O(spg_bufg));
    uart_bmpg_0 uart(
        .upg_clk_i(uart_clk),
        .upg_rst_i(uart_rst),
        .upg_rx_i(rx),
        .upg_clk_o(uart_clk_o),
        .upg_wen_o(uart_write_en),
        .upg_adr_o(uart_addr),
        .upg_dat_o(uart_data),
        .upg_done_o(uart_done),
        .upg_tx_o(tx)
    );
    
    always @ (posedge sys_clk) 
    begin 
        if (spg_bufg) 
            uart_rst = 0; 
        if (rst_in) 
            uart_rst = 1; 
    end
    
     always @(*) begin
         pending_interrupts[0] = systick_clk;
     end

     integer i;
     always @(posedge clk or posedge rst) begin
        if (rst) begin
            pending_interrupts[8:1] <= 0;
            for (i = 0; i < 6; i = i + 1) begin
                gpio_in_buffers[i] <= 0;
            end
        end
        else begin
            if (gpio_a_out != gpio_in_buffers[0] && exti_enable[0]) begin
                pending_interrupts[1] <= 1;
                gpio_in_buffers[0] <= gpio_a_out;
            end
            else pending_interrupts[1] <= 0;

            if (gpio_b_out != gpio_in_buffers[1] && exti_enable[1]) begin
                pending_interrupts[2] <= 1;
                gpio_in_buffers[1] <= gpio_b_out;
            end
            else pending_interrupts[2] <= 0;

            if (gpio_c_out != gpio_in_buffers[2] && exti_enable[2]) begin
                pending_interrupts[3] <= 1;
                gpio_in_buffers[2] <= gpio_c_out;
            end
            else pending_interrupts[3] <= 0;

            if (gpio_d_out != gpio_in_buffers[3] && exti_enable[3]) begin
                pending_interrupts[4] <= 1;
                gpio_in_buffers[3] <= gpio_d_out;
            end
            else pending_interrupts[4] <= 0;

            if (gpio_e_out != gpio_in_buffers[4] && exti_enable[4]) begin
                pending_interrupts[5] <= 1;
                gpio_in_buffers[4] <= gpio_e_out;
            end
            else pending_interrupts[5] <= 0;

            // if (gpio_f_out != gpio_in_buffers[5]) && exti_enable[5] begin
            //     pending_interrupts[6] <= 1;
            //     gpio_in_buffers[5] <= gpio_f_out;
            // end
            // else pending_interrupts[6] <= 0;
        end
     end
    
    
//    initial begin 
//        sys_clk = 0;
//        rst_in = 1;
//        start_pg = 0;
//        #11 rst_in = 0;
//    end
    
//    always #3 sys_clk = ~sys_clk;
    
endmodule
