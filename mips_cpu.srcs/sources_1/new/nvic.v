`timescale 1ns / 1ps

module nvic(
    input clk, rst,
    input[31:0] next_pc,
    input[8:0] arriving_interrupts,
    input is_eret,
    output need_jump,
    output[31:0] target_addr,
    output[8:0] int_en
);

// posedge: ����interrupt_en��
// comb: �����eret��interrupt_en��0��need_jump��1��target_addrΪepc_all[current]��
// comb: ��������ȼ����ߵ�exception��need_jump��1��target_addrΪ0xfc+cause��
// �����exception��ת��д��Ӧ��epc_all��
// ��Ϊ��дnext_pc�����Բ���Ҫmfc��mtc�ˡ�Ҳ���ÿ����쳣�Ƿ񴥷���jump���
// �����eret, next_pc��epc_all[current]�������ⲿ��������

reg[31:0] epc_all[8:0];
wire[31:0] next_pc_with_eret;
reg[3:0] current_interrupt;
wire[3:0] next_interrupt;
reg[8:0] interrupt_en;

assign int_en = interrupt_en;

assign next_pc_with_eret = is_eret ? epc_all[current_interrupt] : next_pc;
assign target_addr = interrupt_en == 0 ? next_pc_with_eret : (32'h4180 + {next_interrupt, 2'b00});
assign need_jump = current_interrupt != next_interrupt;

priority_encoder enc(interrupt_en, next_interrupt);

integer i;
always @(posedge clk) begin
    if (is_eret) begin
        interrupt_en[current_interrupt] = 0;
    end
    interrupt_en = interrupt_en | arriving_interrupts;
end

always @(negedge clk) begin
    current_interrupt = next_interrupt;
    epc_all[next_interrupt] = next_pc_with_eret;
end

always @(negedge rst) begin
    current_interrupt = 0;
    interrupt_en = 0;
    for (i = 0; i < 9; i = i + 1) begin
        epc_all[i] = 0;
    end
end

endmodule