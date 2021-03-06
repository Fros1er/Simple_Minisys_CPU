`timescale 1ns / 1ps

module ifetch(
    input clk, nvic_clk, rst,
    input [31:0] result,
    input [8:0] pending_interrupts,
    input is_usage_fault,
    output alu_en,
    output [1:0] alu_type, // 01 R 00 I 10 coproc1
    output [4:0] rs,
    output [4:0] rt,
    output [4:0] rd,
    output [15:0] immediate,
    output [4:0] shamt,
    output [5:0] funct,
    output [5:0] opcode,
    output reg [31:0] return_addr,
    // UART
    input program_off, uart_clk, uart_write_en, 
    input [13:0] uart_addr,
    input [31:0] uart_data
//     ,output [31:0] pc_sim, instruction,
//     output need_exception_jump, is_eret, is_ready,
//     output [31:0] target_addr
//    ,output [31:0] epc0,
//    output[8:0] int_en, arr,
//    output[3:0]curr, next
);
     

    wire [31:0] instruction, target_addr;
    wire is_eret, need_exception_jump;

    reg ready;
    reg[31:0] pc;
    wire[31:0] next_pc, pcplus4;
    wire is_trap;
//    assign pc_sim = pc;
//    assign is_ready = ready;
    
    assign is_eret = instruction == 32'h42000018;
    assign pcplus4 = pc + 4;
    
    inst_memory mem(
        .clka(program_off ? clk : uart_clk),
        .addra(program_off ? pc >> 2 : uart_addr),
        .douta(instruction),
        .dina(program_off ? 32'b0 : uart_data),
        .wea(program_off ? 0 : uart_write_en)
    );
    
    assign funct = instruction[5:0];
    assign opcode = instruction[31:26];
    assign rs = instruction[25:21];
    assign rt = instruction[20:16];
    assign rd = opcode == 6'b00_0011 ? 31 : instruction[15:11]; 
    assign immediate = instruction[15:0];
    assign shamt = instruction[10:6];
    assign is_trap = (opcode == 6'b0 && funct[5:2] == 4'b1101) || // teq, tne
                     opcode == 6'b00_0001; // teqi, tnei
    assign alu_en = instruction != 0 &&
                    opcode != 6'b00_0010 && 
                    opcode != 6'b00_0011 &&
                    !(opcode == 6'b01_0000 && !is_eret); // coproc0
    assign alu_type = (opcode == 6'b00_0000) ? 2'b01 :
                      (opcode == 6'b01_0000) ? 2'b10 : 2'b00;
    
    // ????????????next_pc
    assign next_pc = (instruction[31:28] == 4'b00_01 && result[0] == 1) ? pc + 4 + {{14{instruction[15]}}, instruction[15:0], 2'b00} : // bne or beq
                     (instruction[31:27] == 6'b00_001) ? {pcplus4[31:28], instruction[25:0], 2'b00} : // jump and jal
                     (instruction[31:26] == 6'b00_0000 && instruction[5:0] == 6'b00_1000) ? result : // jr
                     pc + 4;
    
    nvic nvic_t(
        .clk(clk),
        .nvic_clk(nvic_clk),
        .rst(rst),
        .ready(ready),
        .next_pc(next_pc),
        .arriving_interrupts(pending_interrupts | {is_usage_fault, is_trap & result[0], 7'b0}),
        .is_eret(is_eret),
        .need_jump(need_exception_jump),
        .target_addr(target_addr)
//        ,.int_en(int_en),.arr(arr),.curr(curr),.next(next),.epc0(epc0)
    );
    
    always @(posedge clk) begin
        ready <= rst ? 0 : 1;
    end
    
    always @(negedge clk or posedge rst) begin
        if (rst) begin
            pc = 32'b0;
            return_addr <= 0;
        end 
        else begin
            return_addr <= pc + 4;
            if (ready) begin
                pc = (need_exception_jump ? target_addr : next_pc);
            end
        end
    end

endmodule

