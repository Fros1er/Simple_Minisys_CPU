`timescale 1ns / 1ps

module nvic(
    input clk, rst, ready, nvic_clk,
    input[31:0] next_pc,
    input[8:0] arriving_interrupts,
    input is_eret,
    output need_jump,
    output[31:0] target_addr, epc0,
    output[8:0] int_en,
    output[8:0] arr,
    output[3:0] curr, next
);



// posedge: 更新interrupt_en。
// comb: 如果是eret，interrupt_en置0，need_jump置1，target_addr为epc_all[current]。
// comb: 如果有优先级更高的exception，need_jump置1，target_addr为0xfc+cause。
// 如果有exception跳转，写对应的epc_all。
// 因为是写next_pc，所以不需要mfc和mtc了。也不用考虑异常是否触发在jump那里。
// 如果是eret, next_pc是epc_all[current]。否则外部传过来。

reg[31:0] epc_all[8:0];
reg[3:0] current_interrupt;
wire[3:0] next_interrupt;
reg[8:0] interrupt_en, interrupt_pending;
wire[9:0] highest_bit;

reg eret_lock;

assign arr = arriving_interrupts;
assign curr = current_interrupt;
assign next = next_interrupt;
assign int_en = interrupt_en;
assign epc0 = epc_all[0];

assign target_addr = (interrupt_en == 0 || interrupt_pending[next_interrupt - 1]) ? epc_all[current_interrupt - 1] : (32'h4180 + {next_interrupt - 1, 2'b00});
assign need_jump = next_interrupt > current_interrupt || is_eret;

priority_encoder enc(interrupt_en, next_interrupt);

assign highest_bit = 10'b0000_0000_01 << current_interrupt;

integer i;
always @(negedge nvic_clk) begin
    if (ready) begin
        if (is_eret && !eret_lock) begin
            eret_lock = 1;
            interrupt_en = (interrupt_en | arriving_interrupts) & (~highest_bit[9:1]);
        end
        else begin
            interrupt_en = interrupt_en | arriving_interrupts;
        end
    end
end

always @(posedge clk) begin
    eret_lock = 0;
end

always @(negedge clk) begin
    if (is_eret) begin
        interrupt_pending[current_interrupt - 1] = 0;
    end
    if (need_jump && interrupt_en != 0 &&  interrupt_pending[next_interrupt - 1] == 0) begin
        interrupt_pending[next_interrupt - 1] = 1;
        epc_all[next_interrupt - 1] = is_eret ? epc_all[current_interrupt - 1] : next_pc;
    end
    current_interrupt = next_interrupt;
end

always @(negedge rst) begin
    current_interrupt = 0;
    interrupt_en = 0;
    eret_lock = 0;
    interrupt_pending = 0;
    for (i = 0; i < 9; i = i + 1) begin
        epc_all[i] <= 0;
    end
end

endmodule