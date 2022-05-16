`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/16 17:16:49
// Design Name: 
// Module Name: cpu_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module cpu_top(
//        input sys_clk, rst,
    output[31:0] gpio_a, gpio_b, gpio_c, gpio_d, gpio_e, gpio_f
);
    
    reg sys_clk;
    reg rst;
    
    wire clk, uart_clk, systick_clk, rd_write_enable, rt_write_enable, alu_en, mem_write_en, io_write_en, is_sw, is_io_target, is_trap, is_usage_fault, interrupt, is_eret, is_kernel;
    wire [1:0] alu_type;
    
    
    wire[31:0] pc, cause_sim, epc_sim, next_pc_sim, instruction_sim, seg_sim;
    
    wire[4:0] rd, rs, rt, shamt;
    wire[5:0] funct, opcode;
    wire[9:0] io_access_target;
    wire[15:0] immediate;
    wire[31:0] rs_val, rt_val, reg_write_val;
    wire[31:0] result, return_addr;
    wire[31:0] mem_access_target, mem_write_val, mem_io_read_val, mem_read_val, io_read_val;
    
    reg pending_interrupt;
    reg [3:0] cause;
    
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
    assign mem_io_read_val = is_io_target ? io_read_val : mem_read_val;
    
    assign interrupt = !is_kernel && ((is_trap && result) || is_usage_fault || pending_interrupt);
//    assign interrupt = !kernel_mode && ((is_trap && result) || is_usage_fault);
    
    wire clk_t;
//    cpuclk clk_d(
//        .sys_clk(sys_clk),
//        .clk(clk),
//        .uart_clk(uart_clk)
//    );
    
//    clock_div #(.period(100), .width(7)) cda(uart_clk, rst, clk_t);
//    clock_div #(.period(100), .width(7)) cd(clk_t, rst, systick_clk);
    assign clk = sys_clk;
    clock_div #(.period(100), .width(7)) cd(sys_clk, rst, systick_clk);
    
    ifetch i_fetch(
       .clk(clk),
       .rst(rst),
       .is_interrupt(interrupt),
       .cause((pending_interrupt) ? cause : (is_trap ? 2 : (is_usage_fault ? 1 : 0))),
       .result(result),
       .alu_en(alu_en),
       .is_trap(is_trap),
       .is_kernel(is_kernel),
       .alu_type(alu_type), // 1 R 0 I
       .rs(rs),
       .rt(rt),
       .rd(rd),
       .immediate(immediate),
       .shamt(shamt),
       .funct(funct),
       .opcode(opcode),
       .return_addr(return_addr),
       .pc_sim(pc),
       .instruction(instruction_sim),
       .is_eret(is_eret)
    );
    registers regs(
       .clk(clk),
       .rst(rst),
       .rs(rs),
       .rt(rt),
       .rd(rd),
       .rd_write_enable(rd_write_enable),
       .rt_write_enable(rt_write_enable),
       .move_enable(alu_type == 2'b10 && rs[4] != 1), //coproc0 && not mfc, mtc
       .move_direction(rs == 5'b00100), // mtc0 1 mfc0 0
       .is_coproc(alu_type == 2'b10),
       .is_interrupt(is_trap && result),
       .write_val(reg_write_val),
       .pc(pc),
       .rs_val(rs_val),
       .rt_val(rt_val),
       .epc_sim(epc_sim)
    );
    alu alu_a(
       .alu_en(alu_en),
       .type(alu_type), // 1 for R, 0 for I
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
       .read_val(mem_read_val)
    );
    
    io io_a(
       .clk(clk),
       .rst(rst),
       .write_en(io_write_en),
       .access_target(io_access_target),
       .write_val(mem_write_val),
       .read_val(io_read_val),
       .gpio_a(gpio_a),
       .gpio_b(gpio_b),
       .gpio_c(gpio_c),
       .gpio_d(gpio_d),
       .gpio_e(gpio_e),
       .gpio_f(gpio_f)
    );
    
    always @(posedge clk) begin
        if (is_eret) begin 
            pending_interrupt = 0;
        end
    end
    
    always @(posedge systick_clk) begin
        pending_interrupt = 1;
        cause = 0;
    end
    
    always @(negedge rst) begin
        pending_interrupt = 0;
        cause = 0;
    end
    
    initial begin 
        sys_clk = 0;
        rst = 1;
        #11 rst = 0;
    end
    
    always #1 sys_clk = ~sys_clk;
    
endmodule
