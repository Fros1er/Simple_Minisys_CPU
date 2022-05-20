`timescale 1ns / 1ps

module systick_generator(
    input clk, rst,
    output reg systick
);
    reg [13:0] cnt;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cnt <= 0;
            systick <= 0;
            end
        else begin
            if (cnt == 10000) begin
                systick <= 1;
                cnt <= 0;
            end
            else begin
                systick <= 0;
                cnt <= cnt + 1;
            end
        end
    end

endmodule