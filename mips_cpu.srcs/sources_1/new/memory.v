`timescale 1ns / 1ps

module memory(
    input clk,
    input rst,
    input write_en, // 0 read 1 write
    input[31:0] write_val,
    input[31:0] access_target,
    output[31:0] read_val
);

data_memory mem(
    .clka(~clk),
    .addra(access_target >> 2), 
    .douta(read_val),
    .dina(write_val),
    .wea(write_en)
);

endmodule
