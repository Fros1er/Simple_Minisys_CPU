.data
	cnt: .word 0
	flag: .word 0
	io_start: .word 0xfffffc00

.text 0x0000
start:
loop:  j loop

systick_handler:
	lw $s0, cnt
	addi $s0, $s0, 1
	sw $s0, cnt
	ori $s1, $zero, 1000
	bne $s1, $s0, after_check
	# if (t0 == 1000)
	sw $zero, cnt
	lw $s2, flag
	xori $s2, $s2, 1
	sw $s2, flag
	lw $s3, io_start
	sw $s2, 0($s3)
after_check:
    eret
usagefault_handler:
    eret
trap_handler:
    eret
exti0_handler:
	eret

.text 0x4180
	j systick_handler
	j exti0_handler
	j exti0_handler
	j exti0_handler
	j exti0_handler
	j exti0_handler
	j exti0_handler
    j trap_handler
    j usagefault_handler
