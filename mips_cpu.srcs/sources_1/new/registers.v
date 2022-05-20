`timescale 1ns / 1ps

module registers (
    input clk,
    input rst,
    input[4:0] rs,
    input[4:0] rt,
    input[4:0] rd,
    input rd_write_enable,
    input rt_write_enable,
    // input move_enable,
    // input move_direction,
    input[31:0] write_val,
    output[31:0] rs_val,
    output[31:0] rt_val
);

reg[31:0] regs[0:31];

assign rs_val = regs[rs];
assign rt_val = regs[rt];

integer i;
always @(posedge clk or posedge rst) begin
    if (rst) begin
        for (i = 0; i < 29; i = i + 1) begin
            regs[i] <= 0;
        end
        regs[29] <= 32'h3ffc;
        regs[30] <= 32'b0;
        regs[31] <= 32'b0;
    end
    else begin
        if (rt_write_enable && rt != 0) begin
            regs[rt] = write_val;
        end
        if (rd_write_enable && rd != 0) begin
            regs[rd] = write_val;
        end
    end
end
    
endmodule
