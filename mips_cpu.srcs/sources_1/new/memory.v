`timescale 1ns / 1ps

module memory(
    input clk,
    input rst,
    input write_en, // 0 read 1 write
    input[31:0] write_val,
    input[31:0] access_target,
    output[31:0] read_val,
    // UART
    input program_off, uart_clk, uart_write_en, 
    input [13:0] uart_addr,
    input [31:0] uart_data
);

data_memory mem(
    .clka(program_off ? ~clk : uart_clk),
    .addra(program_off ? access_target >> 2 : uart_addr), 
    .douta(read_val),
    .dina(program_off ? write_val : uart_data),
    .wea(program_off ? write_en : uart_write_en)
);

endmodule
