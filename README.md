# Simple_Minisys_CPU

南科大CS202计算机组成原理的final project

还在咕，目前的打算是写一个带简单的中断和简单的GPIO的小玩意，然后用它来让电机转一下(

顺便，这玩意的指令长度实际是17位...因为不想开太大的block mem存指令

.ktext在0x4000，是跟着mars来的。由于这玩意没有内核态所以直接当text处理了...

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
- [x] nop

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
- [ ] UART Download
  
## Bonus

### Basics
- [x] ~~minisys_extended to coe compiler~~ Use mars instead
- [ ] c to minisys_extended compiler (opt)

### Registers
- [x] EPC $14

### Instructions

#### Exception (.ktext at 18180)
- [x] ~~mtc0 010000 00100 rt rd 11'0 move rt to rd(cop0)~~
- [x] ~~mfc0 010000 00000 rt rd 11'0 move rd(cop0) to rt~~
- [x] teq 6'b0 rs rt 10'b0 110100
- [x] tne 6'b0 rs rt 10'b0 110110
- [x] teqi 000001 rs 01100 immediate
- [x] tnei 000001 rs 01110 immediate
- [x] eret 010000 1 19'0 011000

### About Exception
- [x] systick
- [x] fault
- [x] trap
- [ ] external
- [x] NVIC, without custom priority...

### IVT ktext里直接写jump模拟
- [x] systick_handler
- [x] usagefault_handler
- [x] trap_handler
- [ ] exti0_handler * 6

### IO
- [ ] GPIO
- [ ] LED1 拨码开关1 按键开关1 键盘1 数码管1 EJTAG1 共计6bytes

### Programs (opt)
- [ ] serial echo server 单独写个模块用来搞时钟？
- [ ] calculator
