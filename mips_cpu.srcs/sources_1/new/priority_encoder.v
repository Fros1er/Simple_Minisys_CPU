`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/17 19:32:12
// Design Name: 
// Module Name: priority_encoder
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


module priority_encoder(
    input [8:0] in,
    output reg [3:0] out
    );
    
    always @ (*)
    begin
        if (in[8] == 1) out = 4'b1001;
        else if (in[7] == 1) out = 4'b1000;
        else if (in[6] == 1) out = 4'b0111;
        else if (in[5] == 1) out = 4'b0110;
        else if (in[4] == 1) out = 4'b0101;
        else if (in[3] == 1) out = 4'b0100;
        else if (in[2] == 1) out = 4'b0011;
        else if (in[1] == 1) out = 4'b0010;
        else if (in[0] == 1) out = 4'b0001;
        else out = 4'b0000;
    end
endmodule
