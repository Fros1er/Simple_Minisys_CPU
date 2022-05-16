`timescale 1ns / 1ps

module registers (
    input clk,
    input rst,
    input[4:0] rs,
    input[4:0] rt,
    input[4:0] rd,
    input rd_write_enable,
    input rt_write_enable,
    input move_enable,
    input move_direction,
    input is_coproc,
    input is_interrupt,
    input[31:0] write_val,
    input[31:0] pc,
    output[31:0] rs_val,
    output[31:0] rt_val,
    output[31:0] epc_sim
);

reg[31:0] regs[0:31];
reg epc;


assign rs_val = is_coproc ? epc : regs[rs];
assign rt_val = regs[rt];
assign epc_sim = epc;

always @(negedge clk) begin
    if (is_interrupt) begin
        epc = pc;
    end
end

always @(posedge clk) begin
    if (rt_write_enable && rt != 0) begin
        regs[rt] = write_val;
    end
    if (rd_write_enable && rd != 0) begin
        regs[rd] = write_val;
    end
    if (is_coproc && move_enable) begin
        if (move_direction) begin //rt to rd
            case(rd)
                5'b01110: epc = regs[rt];
            endcase
        end
        else begin
            case(rd)
                5'b01110: regs[rt] = epc;
            endcase
        end 
    end
end

integer i;
always @(negedge rst) begin
    for (i = 0; i < 32; i = i + 1) begin
        regs[i] <= 0;
    end
    epc <= 0;
end
    
endmodule
