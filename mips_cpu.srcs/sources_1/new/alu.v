`timescale 1ns / 1ps

module alu(
    input alu_en,
    input[1:0] alu_type, // 1 for R, 0 for I
    input[5:0] opcode,
    input[5:0] funct,
    input[4:0] rt, // for teqi & tnei
    input[31:0] rs_val,
    input[31:0] rt_val,
    input[4:0] shamt,
    input[15:0] immediate,
    output reg[31:0] result,
    output is_fault
);

wire[31:0] signextimm;
wire[31:0] zeroextimm;
assign signextimm = {{16{immediate[15]}}, immediate};
assign zeroextimm = {16'b0, immediate};

assign is_fault = (alu_type == 2'b01 && ((funct == 6'b10_0000 && (~(rs_val[31] ^ rt_val[31]) & (rs_val[31] ^ result[31]))) ||
                                    (funct == 6'b10_0010 && ((rs_val[31] ^ rt_val[31]) & (rs_val[31] ^ result[31]))))) ||
                  (alu_type == 2'b00 && opcode == 6'b00_1000 && (~(rs_val[31] ^ signextimm[31]) & (rs_val[31] ^ result[31])));
                   
//(type == 2'b01 && (funct == 6'b10_0000 || funct == 6'b10_0010)) || (type == 2'b00 && opcode == 6'b00_1000) ? 
//                  1 : 0;

always @(*) begin
    if (alu_en) begin
        if (alu_type == 2'b01) begin
            case(funct)
                6'b00_0000: result = rt_val << shamt; // sll
                6'b00_0010: result = rt_val >> shamt; // srl
                6'b00_0100: result = rt_val << rs_val[4:0]; // sllv
                6'b00_0110: result = rt_val >> rs_val[4:0]; // srlv
                6'b00_0011: result = $signed(rt_val) >>> shamt; // sra
                6'b00_0111: result = $signed(rt_val) >>> rs_val[4:0]; // srav
                6'b00_1000: result = rs_val;
                6'b10_0000: result = $signed(rs_val) + $signed(rt_val); // add
                6'b10_0001: result = rs_val + rt_val; // addu, TODO
                6'b10_0010: result = $signed(rs_val) - $signed(rt_val); // sub
                6'b10_0011: result = rs_val - rt_val; // subu, TODO
                6'b10_0100: result = rs_val & rt_val; // and
                6'b10_0101: result = rs_val | rt_val; // or
                6'b10_0110: result = rs_val ^ rt_val; // xor
                6'b10_0111: result = ~(rs_val | rt_val); // nor
                6'b10_1010: result = ($signed(rs_val) < $signed(rt_val)) ? 1 : 0; // slt
                6'b10_1011: result = (rs_val < rt_val) ? 1 : 0; // sltu, TODO
                6'b11_0100: result = rs_val == rt_val; // teq
                6'b11_0110: result = rs_val != rt_val; // tne
                default: result = 0;
            endcase
        end 
        else if (alu_type == 2'b00) begin
            case (opcode)
                6'b00_0001: result = (rt == 5'b01100) ? rs_val == zeroextimm : // teqi
                                     (rt == 5'b01110) ? rs_val != zeroextimm : 0; // tnei
                6'b00_0100: result = (rs_val == rt_val) ? 1 : 0; // beq
                6'b00_0101: result = (rs_val != rt_val) ? 1 : 0; // bne
                6'b00_1000: result = $signed(rs_val) + $signed(signextimm); // addi
                6'b00_1001: result = rs_val + signextimm; // addiu
                6'b00_1010: result = ($signed(rs_val) < $signed(signextimm)) ? 1 : 0; // slti
                6'b00_1011: result = (rs_val < signextimm) ? 1 : 0; // sltiu
                6'b00_1100: result = rs_val & zeroextimm; // andi
                6'b00_1101: result = rs_val | zeroextimm; // ori
                6'b00_1110: result = rs_val ^ zeroextimm; // xori
                6'b00_1111: result = {immediate, 16'b0}; // lui
                default: result = 0;
            endcase
        end 
        else begin
            result = 0;
        end
    end
    else begin
        result = 0;
    end
end

endmodule
