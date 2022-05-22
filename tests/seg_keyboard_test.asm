#GPIOA: red and yellow leds
#GPIOB: switch 0-15
#GPIOC: seg7
#GPIOD: keyboard & button
#GPIOE: 3 leds
#GPIOF: 3 switches

.data
	cnt: .word 0
	flag: .word 0
	io_start: .word 0xfffffc00
	seg_cnt: .word 7
	seg_num: .word 0
    seg: .word 192 249 164 176 153 146 130 248 128 144 136 131 198 161 134 142

	# keyboard: .word 40 17 33 65 18 34 66 20 36 68 129 130 132 136 24 36
    keyboard_now: .word 0
	
.text
start:
	lw $fp, io_start
	ori $s5, $zero, 5 # set t0 000101
	sw $s5, 32($fp)
    ori $s5, $zero, 8 # set exti to 1000
    sw $s5, 36($fp)
	
loop: j loop
	
systick_handler:
    lw $s0, keyboard_now
    sw $s0, seg_num
	jal update_seg
# 	lw	$s0, cnt
# 	addi	$s0, $s0, 1
# 	sw $s0, cnt
# 	ori	$s1, $zero, 500
# 	bne	$s1, $s0, after_check
# 	# if (t0 == 1000)
# 	sw $zero, cnt
# 	lw	$s2, flag
# 	xori $s2, $s2, 2
# 	sw $s2, flag
# 	sw $s2, 0($fp)
# after_check:
    eret

# keyboard
exti3_handler:
    addiu $sp, $sp, -16
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $s3, 12($sp)
	lw $s0, 16($fp)
	sw $s0, seg_num

#     lw $s0, 12($fp)
#     sw $s0, 0($fp)
#     ori $s1, $zero, 0 # now = 0
#     ori $s3, $zero, 60
# exti3_loop_begin:
#     lw $s2, keyboard($s1)
#     beq $s2, $s0, exti3_loop_end
#     addiu $s1, $s1, 4
#     bne $s1, $s3, exti3_loop_begin
#     ori $s1, $zero, 0 # not find, now = 0
# exti3_loop_end:
#     srl $s1, $s1, 2
#     sw $s1 keyboard_now

    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    lw $s3, 12($sp)
    addiu $sp, $sp, 16
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
	j exti3_handler
	j exti0_handler
	j exti0_handler
    j trap_handler
    j usagefault_handler

update_seg:	
	addiu	$sp, $sp, -12
	sw	$2, 4($sp)
	sw	$3, 0($sp)
	sw $s0, 8($sp)
	
	lw	$2, seg_cnt
	ori	$3, $zero, 1
	sllv	$3, $3, $2
	nor	$4, $3, $zero
	sll	$4, $4, 24
	srl	$4, $4, 24
	
	lw	$3, seg_num
	srlv	$3, $3, $2
	srlv	$3, $3, $2
	srlv	$3, $3, $2
	srlv	$3, $3, $2
	andi	$3, $3, 15
	sll	$3, $3, 2
	lw $3, seg($3)
	sll	$3, $3, 8
	or	$4, $4, $3
	sw	$4, 8($fp)
	
	bne	$2, $zero, seg_not_zero
	ori	$2, $zero, 8
	seg_not_zero:
	addi $2, $2, -1
	sw $2, seg_cnt
	
	lw	$2, 4($sp)
	lw	$3, 0($sp)
	lw $s0, 8($sp)
	addiu	$sp, $sp, 12
	jr $ra
	
