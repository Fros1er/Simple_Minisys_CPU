.data
	cnt: .word 0
	flag: .word 0
	io_start: .word 0xfffffc00
	seg_cnt: .word 0

.text 0x0000
start:
	lw	$fp, io_start
	ori	$s7, $zero, 1 # set gpio_out: 000001
	sw	$s7, 32($fp)
	ori 	$s7, $zero, 10 # set exti: 001010
	sw 	$s7, 36($fp)
	ori 	$s7, $zero, 1 # set gpioA: 0x1
	sw 	$s7, 0($fp)
	sw 	$s7, flag
loop:  j loop # while 1

systick_handler:
	lw	$s0, cnt
	addi	$s0, $s0, 1
	sw 	$s0, cnt
	ori	$s1, $zero, 500
	bne	$s1, $s0, after_check
	# if (t0 == 1000)
	sw 	$zero, cnt
	lw	$s2, flag
	xori 	$s2, $s2, 2
	sw 	$s2, flag
	sw 	$s2, 0($fp)
after_check:
	eret
usagefault_handler:
	eret
trap_handler:
	eret
exti0_handler:
	eret
exti1_handler:
	lw $s5, 4($fp) # s5 = gpioB
	sw $s5, 0($fp) # gpioA = gpioB
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
        
        
