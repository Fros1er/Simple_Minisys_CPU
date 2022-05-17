`timescale 1ns / 1ps

module nvic(
    input clk, rst,
    input[31:0] next_pc,
    input[8:0] arriving_interrupts,
    input is_eret,
    output need_jump,
    output[31:0] target_addr
);

// posedge: 更新interrupt_en。
// comb: 如果是eret，interrupt_en置0，need_jump置1，target_addr为epc_all[current]。
// comb: 如果有优先级更高的exception，need_jump置1，target_addr为0xfc+cause。
// 如果有exception跳转，写对应的epc_all。
// 因为是写next_pc，所以不需要mfc和mtc了。也不用考虑异常是否触发在jump那里。
// 如果是eret, next_pc是epc_all[current]。否则外部传过来。

reg[31:0] epc_all[8:0];
wire[31:0] next_pc_with_eret;
reg[3:0] current_interrupt;
wire[3:0] next_interrupt;
reg[8:0] interrupt_en;

assign next_pc_with_eret = is_eret ? epc_all[current_interrupt] : next_pc;
assign target_addr = interrupt_en == 0 ? next_pc_with_eret : (32'h4180 + {next_interrupt, 2'b00});
assign need_jump = current_interrupt != next_interrupt;

priority_encoder(interrupt_en, next_interrupt);

always @(posedge clk) begin
    if (is_eret) begin
        interrupt_en[current_interrupt] = 0;
    end
    integer i;
    for (i = 0; i < 9; i = i + 1) begin
        if (!interrupt_en[i]) begin
            interrupt_en[i] = 1;
        end
    end
end

always @(negedge clk) begin
    current_interrupt = next_interrupt;
    epc_all[next_interrupt] = next_pc_with_eret;
end

always @(negedge rst) begin
    current_interrupt = 0;
    interrupt_en = 0;
end

endmodule