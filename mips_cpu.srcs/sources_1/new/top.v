`timescale 1ns / 1ps

module top(
    //input sys_clk,
    //input rst
    output[7:0] seg_out,
    output[7:0] seg_en
);
    reg sys_clk;
    reg rst;
    
    wire clk,rd_write_enable, rt_write_enable, alu_en, mem_write_en, io_write_en, is_sw, is_io_target;
    wire [1:0] alu_type;
    
    
    wire[31:0] pc_sim, pcdiv4sim, next_pc_sim, instruction_sim, seg_sim;
    
    wire[4:0] rd, rs, rt, shamt;
    wire[5:0] funct, opcode;
    wire[9:0] io_access_target;
    wire[15:0] immediate;
    wire[31:0] rs_val, rt_val, reg_write_val;
    wire[31:0] result, return_addr;
    wire[31:0] mem_access_target, mem_write_val, mem_io_read_val, mem_read_val, io_read_val;
    
    assign reg_write_val = (opcode == 6'b10_0011) ? mem_io_read_val : 
                           (opcode == 6'b00_0011) ? return_addr : result;
    assign rd_write_enable = ((alu_en && alu_type == 2'b01 && funct[5:2] != 4'b1101) || opcode == 6'b00_0011);
    assign rt_write_enable = (alu_en && alu_type == 2'b0 && opcode != 6'b00_0100 && opcode != 6'b00_0101 && opcode != 6'b10_1011) &&
                             (alu_type == 2'b10 && rs == 5'b0); // mfc0
    
    assign is_sw = (opcode == 6'b10_1011);
    assign is_io_target = (mem_access_target[31:10] == 22'b1111_1111_1111_1111_1111_11);
    assign io_write_en = is_sw && is_io_target;
    assign mem_write_en = is_sw && !is_io_target;
    assign mem_write_val = rt_val;
    assign mem_access_target = rs_val + {{16{immediate[15]}}, immediate};
    assign io_access_target = mem_access_target[9:0];
    assign mem_io_read_val = is_io_target ? io_read_val : mem_read_val;
    
    clock_div#(.period(2), .width(3)) clk_d(sys_clk, rst, clk);
    
    ifetch i_fetch(
        .clk(clk),
        .rst(rst),
        .result(result),
        .alu_en(alu_en),
        .alu_type(alu_type), // 1 R 0 I
        .rs(rs),
        .rt(rt),
        .rd(rd),
        .immediate(immediate),
        .shamt(shamt),
        .funct(funct),
        .opcode(opcode),
        .return_addr(return_addr),
        .pc_sim(pc_sim),
        .pcdiv4sim(pcdiv4sim),
        .instruction(instruction_sim)
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
        .type(alu_type), // 1 for R, 0 for I
        .opcode(opcode),
        .funct(funct),
        .rt(rt),
        .rs_val(rs_val),
        .rt_val(rt_val),
        .shamt(shamt),
        .immediate(immediate),
        .result(result)
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
        .sys_clk(sys_clk), 
        .clk(clk),
        .rst(rst),
        .write_en(io_write_en),
        .access_target(io_access_target),
        .write_val(mem_write_val),
        .read_val(io_read_val),
        .seg_out(seg_out),
        .seg_en(seg_en),
        .seg_sim(seg_sim)
    );
    
    initial begin 
        sys_clk = 0;
        rst = 1;
        #11 rst = 0;
    end
    
    always #3 sys_clk = ~sys_clk;
endmodule
