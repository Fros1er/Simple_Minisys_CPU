`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/20 21:02:11
// Design Name: 
// Module Name: uart_sim
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


module uart_sim(

    );
    
    reg clk, rst, rx;
    wire clk_o, wen, done, tx;
    wire[14:0] addr;
    wire[31:0] dat;
    
    uart_bmpg_0 uart(
        .upg_clk_i(clk),
        .upg_rst_i(rst),
        .upg_rx_i(rx),
        .upg_clk_o(clk_o),
        .upg_wen_o(wen),
        .upg_adr_o(addr),
        .upg_dat_o(dat),
        .upg_done_o(done),
        .upg_tx_o(tx)
    );
    
    initial begin 
        clk = 0;
        rst = 0;
        rx = 1;
        #11 rst = 1;
        repeat(100) begin
            rx = ~rx;
            #1 clk = ~clk;
        end
    end
    
//    always #3 sys_clk = ~sys_clk;
    
endmodule
