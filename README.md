# Simple_Minisys_CPU

南科大CS202计算机组成原理的final project

还在咕，目前的打算是写一个带简单的中断和简单的GPIO的小玩意，然后用它来让电机转一下(

顺便，这玩意的指令长度实际是17位...因为不想开太大的block mem存指令

# 进度
## Basics
### Instructions
#### R types
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

#### I types
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

#### J types
- [x] jump
- [x] jal

### IO
- [ ] Seg tubes
- [ ] switches
- [ ] Serial
  
## Bonus

### Basics
- [ ] minisys_extended to coe compiler
- [ ] c to minisys_extended compiler (opt)

### Registers
- [ ] Vaddr $8 (opt)
- [ ] Status $12 (opt)
- [ ] Cause $13 4'b0 (exec code only)
- [ ] EPC $14

### Instructions

#### Exception (.ktext at 18180)
- [ ] mtc0 010000 00100 rt rd 11'0 move rt to rd(cop0)
- [ ] mfc0 010000 00000 rt rd 11'0 move rd(cop0) to rt
- [ ] teq 6'b0 rs rt 10'b0 110100
- [ ] tne 6'b0 rs rt 10'b0 110110
- [ ] teqi 000001 rs 01100 immediate
- [ ] tnei 000001 rs 01110 immediate
- [ ] eret 010000 1 19'0 011000
- [ ] syscall 6'b0 20'0 001100 (opt)

#### additional
- [ ] IVT
- [ ] coproc0

### IO
- [ ] GPIO
- [ ] Leds (opt)
- [ ] keyboard (opt)

### Programs (opt)
- [ ] servo motor
