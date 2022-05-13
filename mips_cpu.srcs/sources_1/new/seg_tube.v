`timescale 1ns / 1ps

module seg_tube(
    input [31:0] nums,
    input sys_clk, rst,
    output reg [7:0] seg_out,
    output reg [7:0] seg_en
);
    wire clk, clk_t;
    clock_div #(.period(100), .width(7)) cda(sys_clk, rst, clk_t);
    clock_div #(.period(100), .width(7)) cd(clk_t, rst, clk);
    reg [2:0] cnt = 0;
    reg [3:0] data = 0;
    always @(posedge clk or negedge rst)
    begin
        if (rst) begin 
            cnt <= 0;
            data <= 0;
            seg_en <= 8'b1111_1111;
        end
        else begin
            cnt <= cnt + 1;
            case(cnt)
                0: seg_en <= 8'b1111_1110;
                1: seg_en <= 8'b1111_1101;
                2: seg_en <= 8'b1111_1011;
                3: seg_en <= 8'b1111_0111;
                4: seg_en <= 8'b1110_1111;
                5: seg_en <= 8'b1101_1111;
                6: seg_en <= 8'b1011_1111;
                default: seg_en <= 8'b0111_1111;
            endcase
            case(cnt)
                6: data <= nums[31:28];
                5: data <= nums[27:24];
                4: data <= nums[23:20];
                3: data <= nums[19:16];
                2: data <= nums[15:12];
                1: data <= nums[11:8];
                0: data <= nums[7:4];
                default: data <= nums[3:0];
            endcase
            if (cnt == 2)
                case(data)
                    4'd0: seg_out<=8'b0100_0000;  // 0
                    4'd1: seg_out<=8'b0111_1001;  // 1
                    4'd2: seg_out<=8'b0010_0100;  // 2
                    4'd3: seg_out<=8'b0011_0000;  // 3
                    4'd4: seg_out<=8'b0001_1001;  // 4
                    4'd5: seg_out<=8'b0001_0010;  // 5
                    4'd6: seg_out<=8'b0000_0010;  // 6
                    4'd7: seg_out<=8'b0111_1000;  // 7
                    4'd8: seg_out<=8'b0000_0000;  // 8
                    4'd9: seg_out<=8'b0001_0000;  // 9
                    4'ha: seg_out=8'b0000_1000;  // A
                    4'hb: seg_out=8'b0000_0011;  // b
                    4'hc: seg_out=8'b0100_0110;  // c
                    4'hd: seg_out=8'b0010_0001;  // d
                    4'he: seg_out=8'b0000_0110;  // E
                    4'hf: seg_out=8'b0000_1110;  // F
                    default: seg_out <= 8'b1111_1111;
                endcase
            else
                case(data)
                    4'd0: seg_out<=8'b1100_0000;  // 0
                    4'd1: seg_out<=8'b1111_1001;  // 1
                    4'd2: seg_out<=8'b1010_0100;  // 2
                    4'd3: seg_out<=8'b1011_0000;  // 3
                    4'd4: seg_out<=8'b1001_1001;  // 4
                    4'd5: seg_out<=8'b1001_0010;  // 5
                    4'd6: seg_out<=8'b1000_0010;  // 6
                    4'd7: seg_out<=8'b1111_1000;  // 7
                    4'd8: seg_out<=8'b1000_0000;  // 8
                    4'd9: seg_out<=8'b1001_0000;  // 9
                    4'ha: seg_out=8'b0000_1000;  // A
                    4'hb: seg_out=8'b0000_0011;  // b
                    4'hc: seg_out=8'b0100_0110;  // c
                    4'hd: seg_out=8'b0010_0001;  // d
                    4'he: seg_out=8'b0000_0110;  // E
                    4'hf: seg_out=8'b0000_1110;  // F
                    default: seg_out <= 8'b1111_1111;
                endcase
        end
    end
endmodule
