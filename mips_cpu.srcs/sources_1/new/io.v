`timescale 1ns / 1ps

module io(
    input sys_clk, 
    input clk,
    input rst,
    input write_en,
    input[9:0] access_target,
    input[31:0] write_val,
    output[31:0] read_val,
    output [7:0] seg_out,
    output [7:0] seg_en,
    
    output[31:0] seg_sim
);
    reg[31:0] io_buffer[1:0];
    
    assign read_val = io_buffer[access_target];
    assign seg_sim = io_buffer[0];
    
    always @(negedge clk) begin
        if (write_en) begin
            io_buffer[access_target] <= write_val;
        end
    end
    
    integer i;
    always @(negedge rst) begin
        for (i = 0; i < 2; i = i + 1) begin
            io_buffer[i] <= 0;
        end
    end
    
    seg_tube seg(
        .nums(io_buffer[0]),
        .sys_clk(sys_clk),
        .rst(rst),
        .seg_out(seg_out),
        .seg_en(seg_en)
    );
endmodule
