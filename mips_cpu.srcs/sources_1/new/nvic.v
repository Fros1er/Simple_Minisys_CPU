`timescale 1ns / 1ps

module nvic(
    input clk, rst, ready, nvic_clk,
    input[31:0] next_pc,
    input[8:0] arriving_interrupts,
    input is_eret,
    output need_jump,
    output[31:0] target_addr
//    ,output[31:0] epc0,
//    output[8:0] int_en,
//    output[8:0] arr,
//    output[3:0] curr, next
);

// posedge: ����interrupt_en��
// comb: �����eret��interrupt_en��0��need_jump��1��target_addrΪepc_all[current]��
// comb: ��������ȼ����ߵ�exception��need_jump��1��target_addrΪ0xfc+cause��
// �����exception��ת��д��Ӧ��epc_all��
// ��Ϊ��дnext_pc�����Բ���Ҫmfc��mtc�ˡ�Ҳ���ÿ����쳣�Ƿ񴥷���jump���
// �����eret, next_pc��epc_all[current]�������ⲿ��������

reg[31:0] epc_all[8:0];
reg[3:0] current_interrupt;
wire[3:0] next_interrupt, nextminus1, currminus1;
reg[8:0] interrupt_en, interrupt_pending;
wire[9:0] highest_bit;

assign nextminus1 = next_interrupt - 1;
assign currminus1 = current_interrupt - 1;

//assign arr = arriving_interrupts;
//assign curr = current_interrupt;
//assign next = next_interrupt;
//assign int_en = interrupt_en;
//assign epc0 = epc_all[0];

assign target_addr = (interrupt_en == 0 || interrupt_pending[nextminus1]) ? epc_all[currminus1] : (32'h4180 + {nextminus1, 2'b00});
assign need_jump = next_interrupt > current_interrupt || is_eret;

priority_encoder enc(interrupt_en, next_interrupt);

assign highest_bit = 10'b0000_0000_01 << current_interrupt;

integer i;
always @(negedge nvic_clk) begin
    if (ready) begin
        if (is_eret && clk) begin
            interrupt_en = (interrupt_en | arriving_interrupts) & (~highest_bit[9:1]);
        end
        else begin
            interrupt_en = interrupt_en | arriving_interrupts;
        end
    end
    else begin
        interrupt_en <= 0;
    end
end

always @(negedge clk or posedge rst) begin
    if (rst) begin
        current_interrupt <= 0;
        interrupt_pending <= 0;
        for (i = 0; i < 9; i = i + 1) begin
            epc_all[i] <= 0;
        end
    end
    else begin
        if (is_eret) begin
            interrupt_pending[currminus1] = 0;
        end
        if (need_jump && interrupt_en != 0 &&  interrupt_pending[nextminus1] == 0) begin
            interrupt_pending[nextminus1] = 1;
            epc_all[nextminus1] = is_eret ? epc_all[currminus1] : next_pc;
        end
        current_interrupt = next_interrupt;
    end
end

endmodule