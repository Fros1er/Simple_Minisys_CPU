.data
	cnt: .word 0
	flag: .word 0
	io_start: .word 0xfffffc00
	seg_cnt: .word 0

.text 0x0000
start:
	lw $s6, io_start
	
	addi $s6, $s6, 32 # set gpio_out: 000001
	ori $s7, $zero, 1
	sw $s7, 0($s6)
	
	addi $s6, $s6, 4 # set exti: 001010
	ori $s7, $zero, 10
	sw $s7, 0($s6)
	
	ori $s7, $zero, 1 # set gpioA: 0x1
	lw $s6, io_start
	sw $s7, 0($s6)
	sw $s7, flag

loop:  j loop # while 1

systick_handler:
	lw $s7, io_start
	lw $s0, cnt #cnt++
	addi $s0, $s0, 1
	sw $s0, cnt

	ori $s1, $zero, 500 # if (cnt == 500)
	bne $s1, $s0, after_check
		sw $zero, cnt # cnt = 0

		lw $s2, flag # flag ^= 0b10
		xori $s2, $s2, 2
		sw $s2, flag
		
		sw $s2, 0($s7) # set gpioA: flag
after_check:
	eret
usagefault_handler:
	eret
trap_handler:
	eret
exti0_handler:
	eret
exti1_handler:
	lw $s6, io_start
	lw $s5, 4($s6) # s5 = gpioB
	sw $s5, $s6 # gpioA = gpioB
	eret
exti3_handler:
	eret

.text 0x4180
	j systick_handler
	j exti0_handler
	j exti1_handler # switch
	j exti0_handler
	j exti3_handler
	j exti0_handler
	j exti0_handler
	j trap_handler
	j usagefault_handler
        
        
