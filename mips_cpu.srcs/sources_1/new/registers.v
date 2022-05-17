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
    input[31:0] pc,
    output[31:0] rs_val,
    output[31:0] rt_val,
    output[31:0] epc_sim
);

reg[31:0] regs[0:31];

// assign rs_val = is_coproc ? epc : regs[rs];
assign rs_val = regs[rs];
assign rt_val = regs[rt];

always @(posedge clk) begin

    if (rt_write_enable && rt != 0) begin
        regs[rt] = write_val;
    end
    if (rd_write_enable && rd != 0) begin
        regs[rd] = write_val;
    end
end

integer i;
always @(negedge rst) begin
    for (i = 0; i < 32; i = i + 1) begin
        regs[i] <= 0;
    end
end
    
endmodule
