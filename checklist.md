http://hades.mech.northwestern.edu/images/1/16/MIPS32_Architecture_Volume_II-A_Instruction_Set.pdf

# Basics
## Instructions
### R types
- [x] sll
- [x] srl
- [x] sllv
- [x] srlv
- [x] sra
- [x] srav
- [x] jr
- [x] add
- [x] addu
- [x] sub
- [x] subu
- [x] and
- [x] or
- [x] xor
- [x] nor
- [x] slt
- [x] sltu

### I types
- [x] beq
- [x] bne
- [x] lw (mem)
- [x] sw (mem)
- [x] lw (io)
- [x] sw (io)
- [x] addi
- [x] addiu
- [x] slti
- [x] sltiu
- [x] andi
- [x] ori
- [x] xori
- [x] lui

### J types
- [x] jump
- [x] jal

## IO
- [ ] Seg tubes
- [ ] switches
- [ ] Serial
  
# Bonus

## Basics
- [ ] minisys_extended to coe compiler
- [ ] c to minisys_extended compiler (opt)

## Registers
- [ ] Vaddr $8 (opt)
- [ ] Status $12 (opt)
- [ ] Cause $13 4'b0 (exec code only)
- [ ] EPC $14

## Instructions

### Exception (.ktext at 18180)
- [ ] mtc0 010000 00100 rt rd 11'0 move rt to rd(cop0)
- [ ] mfc0 010000 00000 rt rd 11'0 move rd(cop0) to rt
- [ ] teq 6'b0 rs rt 10'b0 110100
- [ ] tne 6'b0 rs rt 10'b0 110110
- [ ] teqi 000001 rs 01100 immediate
- [ ] tnei 000001 rs 01110 immediate
- [ ] eret 010000 1 19'0 011000
- [ ] syscall 6'b0 20'0 001100 (opt)

### additional
- [ ] IVT
- [ ] coproc0

## IO
- [ ] GPIO
- [ ] Leds (opt)
- [ ] keyboard (opt)

## Programs (opt)
- [ ] servo motor
<!-- - [ ] Serial echo server -->
<!-- - [ ] M! U! G!!!!!!! -->
