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
    
    always @ (in)
    begin
    case (in)
        9'b000000001: out = 4'b001;
        9'b00000001x: out = 4'b010;
        9'b0000001xx: out = 4'b011;
        9'b000001xxx: out = 4'b100;
        9'b00001xxxx: out = 4'b101;
        9'b0001xxxxx: out = 4'b110;
        9'b001xxxxxx: out = 4'b111;
        9'b01xxxxxxx: out = 4'b1000;
        9'b1xxxxxxxx: out = 4'b1001;
        default: out=4'b0;
    endcase
    end
endmodule
