import sys, re

opcode_types = {
    'beq': '000100',
    'bne': '000101',
    'lw': '100011',
    'sw': '101011',
    'addi': '001000',
    'addiu': '001001',
    'slti': '001010',
    'sltiu': '001011',
    'andi': '001100',
    'ori': '001101',
    'xori': '001110',
    'lui': '001111',
    'jump': '000010',
    'jal': '000011'
}

r_types = {
    'sll': '000000',
    'srl': '000010',
    'sllv': '000100',
    'srlv': '000110',
    'sra': '000011',
    'srav': '000111',
    'jr': '001000',
    'add': '100000',
    'addu': '100001',
    'sub': '100010',
    'subu': '100011',
    'and': '100100',
    'or': '100101',
    'xor': '100110',
    'nor': '100111',
    'slt': '101010',
    'sltu': '101011'
}

reg_types = {
    '$zero': '00000',
    '$at': '00001',
    '$v0': '00010',
    '$v1': '00011',
    '$a0': '00100',
    '$a1': '00101',
    '$a2': '00110',
    '$a3': '00111',
    '$t0': '01000',
    '$t1': '01001',
    '$t2': '01010',
    '$t3': '01011',
    '$t4': '01100',
    '$t5': '01101',
    '$t6': '01110',
    '$t7': '01111',
    '$s0': '10000',
    '$s1': '10001',
    '$s2': '10010',
    '$s3': '10011',
    '$s4': '10100',
    '$s5': '10101',
    '$s6': '10110',
    '$s7': '10111',
    '$t8': '11000',
    '$t9': '11001',
    '$k0': '11010',
    '$k1': '11011',
    '$gp': '11100',
    '$sp': '11101',
    '$fp': '11110',
    '$ra': '11111',
    '$8': '01000',
    '$12': '01100',
    '$13': '01101',
    '$14': '01110'
}

modes = {
    '.data': 1,
    '.text': 0,
    '.ktext': 2
}

mode = 0 # 0 text 1 data 2 ktext

line_cnt = 0
inst_cnt = 0

labels = {}

def parse_instruction(line):
    global inst_cnt
    raw_asm = line.split(':')
    if len(raw_asm) == 2: # has label
        label = raw_asm[0].strip()
        if label in labels:
            raise Exception("line %d: duplicated label \"%s\"" % (line_cnt, label))
        labels[label] = inst_cnt * 4
    
    inst = raw_asm[-1].strip()
    if len(inst) == 0:
        return
    inst_parts = re.split(r',\s*|\s+', inst)
    #TODO
    inst_cnt += 1

with open(sys[1], 'r') as f:
    with open(sys[2], 'w') as res:
        for line in f:
            line_cnt += 1
            line = line.strip()
            if len(line) == 0:
                continue
            flag = False
            for key in modes:
                if key in line:
                    mode = modes[key]
                    flag = True
                    break
            if flag:
                continue
        
            
                



        