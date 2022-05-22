.data
	cnt: .word 0
	flag: .word 0
	io_start: .word 0xfffffc00

.text 0x0000
start:
	lw $fp, io_start
	ori $s5, $zero, 1 # set t0 000001
	sw $s5, 32($fp)
    ori $s5, $zero, 2 # set exti to 000010
    sw $s5, 36($fp)
loop:  j loop

systick_handler:
	lw $s0, cnt
	addi $s0, $s0, 1
	sw $s0, cnt
	ori $s1, $zero, 250
	bne $s1, $s0, after_check
	# if (t0 == 1000)
	sw $zero, cnt
	lw $s2, flag
	xori $s2, $s2, 2
	sw $s2, flag
	sw $s2, 0($fp)
after_check:
    eret
exti1_handler:
    ori $s3, 16
    sw $s3, flag
    sw $s3, 0($fp)
    teq $zero, $zero
    eret
trap_handler:
    ori $s3, 4
    sw $s3, flag
    sw $s3, 0($fp)
    lui $s4, 0x7fff
    ori $s4, 0xffff
    add $s4, $s4, $s4
    eret
usagefault_handler:
    lw $s5, flag
    ori $s5, 8
    sw $s5, 0($fp)
uf_loop:  j uf_loop
    eret

exti0_handler:
	eret

.text 0x4180
	j systick_handler
	j exti0_handler
	j exti1_handler
	j exti0_handler
	j exti0_handler
	j exti0_handler
	j exti0_handler
    j trap_handler
    j usagefault_handler
        
        
