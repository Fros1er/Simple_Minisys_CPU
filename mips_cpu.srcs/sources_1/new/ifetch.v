`timescale 1ns / 1ps

module ifetch(
    input clk,
    input rst,
    input [31:0] result,
    input is_interrupt,
    input [3:0] cause,
    output alu_en, is_trap, is_eret, is_kernel,
    output [1:0] alu_type, // 01 R 00 I 10 coproc1
    output [4:0] rs,
    output [4:0] rt,
    output [4:0] rd,
    output [15:0] immediate,
    output [4:0] shamt,
    output [5:0] funct,
    output [5:0] opcode,
    output reg [31:0] return_addr,
    output [31:0] pc_sim,
    output [31:0] pcdiv4sim,
    output [31:0] instruction
);
    reg kernel_mode;
    reg[31:0] pc = 32'b0;
    wire[31:0] next_pc;
    
    assign pc_sim = pc;
    assign pcdiv4sim = pc >> 2;
    assign is_eret = instruction == 32'h42000018;
    assign is_kernel = kernel_mode;
    
    inst_memory mem(.addra(pc >> 2), .clka(clk), .douta(instruction));
    
    assign alu_en = instruction[31:26] != 6'b00_0010 && 
                    instruction[31:26] != 6'b00_0011 &&
                    !(instruction[31:26] == 6'b01_0000 && !is_eret); // coproc0
    assign alu_type = (instruction[31:26] == 6'b00_0000) ? 2'b01 :
                      (instruction[31:26] == 6'b01_0000) ? 2'b10 : 2'b00;
    assign funct = instruction[5:0];
    assign opcode = instruction[31:26];
    assign rs = instruction[25:21];
    assign rt = instruction[20:16];
    assign rd = instruction[31:26] == 6'b00_0011 ? 31 : instruction[15:11]; 
    assign immediate = instruction[15:0];
    assign shamt = instruction[10:6];
    assign next_pc = pc + 4;
    assign is_trap = opcode == (6'b0 && funct[5:2] == 4'b1101) || // teq, tne
                     opcode == 6'b00_0001; // teqi, tnei
    
    always @(negedge clk) begin
        return_addr <= pc + 8;
        if (is_interrupt) begin // teq, tne, teqi, tnei
            kernel_mode = 1;
            pc <= (32'h4180 + {cause, 2'b00});
        end
        else if (instruction[31:28] == 4'b00_01 && result[0] == 1) begin //bne or beq
            pc <= next_pc + {{14{instruction[15]}}, instruction[15:0], 2'b00};
        end
        else if (instruction[31:27] == 6'b00_001) begin //jump and jal
            pc <= {next_pc[31:28], instruction[25:0], 2'b00};
        end
        else if ((instruction[31:26] == 6'b00_0000 && instruction[5:0] == 6'b00_1000) || is_eret) begin // jr && eret
            if (is_eret) kernel_mode = 0;
            pc <= result;
        end
        else begin
            pc <= next_pc;
        end
    end
    
    always @(negedge rst) begin
        kernel_mode = 0;
        pc = 32'b0;
    end

endmodule

