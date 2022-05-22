#GPIOA: red and yellow leds
#GPIOB: switch 0-15
#GPIOC: seg7
#GPIOD: button
#GPIOE: keyboard
#GPIOF: none

.data
	cnt: .word 0
	# flag: .word 0
	io_start: .word 0xfffffc00

	seg_cnt: .word 7
	seg_num: .word 0
    seg: .word 192 249 164 176 153 146 130 248 128 144 136 131 198 161 134 142

    btn_debounce: .word 0

    keyboard_now: .word 0

    type: .word 0
    nums: .word 0 0
    stage: .word 0
    palindrome: .word 0
	
.text
start:
	lw $fp, io_start
	ori $s5, $zero, 5 # set t0 000101
	sw $s5, 32($fp)
    ori $s5, $zero, 26 # set exti to 011010
    sw $s5, 36($fp)
	
loop: j loop
	
systick_handler:
    lw $s0, stage
    lw $s1, palindrome
    sll $s1, $s1, 5
    or $s0, $s0, $s1
    sw $s0, 0($fp)
    ori $s0, $zero, 2
    lw $s1, stage
    beq $s0, $s1, is_not_input
    lw $s1, seg_num
    lui $s0, 0xffff
    ori $s0, $s0, 0xfff0
    and $s1, $s1, $s0
    lw $s0, keyboard_now
    or $s0, $s1, $s0
    sw $s0, seg_num
is_not_input:
    jal update_seg
    jal update_result

	lw	$s0, cnt
	addi	$s0, $s0, 1
	sw $s0, cnt
	ori	$s1, $zero, 500
	bne	$s1, $s0, after_check
	sw $zero, cnt
    sw $zero, btn_debounce
	# lw $s2, flag
	# xori $s2, $s2, 2
	# sw $s2, flag
	# sw $s2, 0($fp)
after_check:
    eret

#switches
exti1_handler:
    addiu $sp, $sp, -4
    sw $s0, 0($sp)

    lw $s0, 4($fp)
    sw $s0, type
    # sw $s0, 0($fp)

    lw $s0, 0($sp)
    addiu $sp, $sp, 4
    eret

# button
exti3_handler:
    addiu $sp, $sp, -8
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    lw $s0, btn_debounce
    bne $s0, $zero, exti3_debounced

    lw $s0, 12($fp)
    ori $s1, $zero, 1
    beq $s0, $s1, exti3_right # right 00001
    ori $s1, $zero, 2
    beq $s0, $s1, exti3_left # left 00010
    ori $s1, $zero, 8
    beq $s0, $s1, exti3_confirm # conf 01000
    j exti3_end

exti3_left:
    lw $s0, seg_num
    sll $s0, $s0, 4
    sw $s0, seg_num
    sw $zero, keyboard_now
    j exti3_end
exti3_right:
    lw $s0, seg_num
    lw $s1, seg_num
    sll $s1, $s1, 28
    srl $s1, $s1, 28
    srl $s0, $s0, 4
    sw $s0, seg_num
    sw $s1, keyboard_now
    j exti3_end
exti3_confirm:
    lw $s0, stage
    ori $s1, $zero, 2
    beq $s0, $s1, exti3_is_not_input
    lw $s1, seg_num
    sll $s0, $s0, 2
    sw $s1, nums($s0)
    srl $s0, $s0, 2
    sw $zero, keyboard_now
    sw $zero, seg_num
exti3_is_not_input:
    addi $s0, $s0, 1
    ori $s1, $zero, 3
    bne $s0, $s1, exti3_stage_is_not_3
    ori $s0, $zero, 0
exti3_stage_is_not_3:
    sw $s0, stage
exti3_end:
    ori $s0, $zero, 1
    sw $s0, btn_debounce
exti3_debounced:
    lw $s0, 0($sp)
    lw $s1, 4($sp)
    addiu $sp, $sp, 8
    eret

# keyboard
exti4_handler:
    addiu $sp, $sp, -4
    sw $s0, 0($sp)

	lw $s0, 16($fp)
	sw $s0, keyboard_now

    lw $s0, 0($sp)
    addiu $sp, $sp, 4
    eret

#unused
usagefault_handler:
    eret
trap_handler:
    eret
exti0_handler:
	eret

.text 0x4180
	j systick_handler
	j exti0_handler
	j exti1_handler
	j exti0_handler
	j exti3_handler
	j exti4_handler
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
	
update_result:
    addiu $sp, $sp, -24
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $s3, 12($sp)
    sw $s4, 16($sp)
    sw $s5, 20($sp)

	ori $s0, $zero, 2
    lw $s1, stage
    bne $s0, $s1, res_end # stage != 2

    lw $s0, type
    ori $s1, $zero, 0
    beq $s0, $s1, res_type_0
    ori $s1, $zero, 1
    beq $s0, $s1, res_type_1
    ori $s1, $zero, 2
    beq $s0, $s1, res_type_2
    ori $s1, $zero, 3
    beq $s0, $s1, res_type_3
    ori $s1, $zero, 4
    beq $s0, $s1, res_type_4
    ori $s1, $zero, 5
    beq $s0, $s1, res_type_5
    ori $s1, $zero, 6
    beq $s0, $s1, res_type_6
    ori $s1, $zero, 7
    beq $s0, $s1, res_type_7
    j res_end

res_type_0:
    lw $s0, nums
    sw $s0, seg_num
    # get_palindrome
    ori $s1, $zero, 0
    or $s2, $zero, $s0
res_cnt_digit:
    beq $s2, $zero, res_cnt_digit_end
    addi $s1, $s1, 1
    srl $s2, $s2, 1
    j res_cnt_digit
res_cnt_digit_end:
    srl $s5, $s1, 1
    ori $s2, $zero, 0
res_check_begin:
    beq $s5, $s2, res_check_success
    srlv $s3, $s0, $s2
    andi $s3, $s3, 1
    sub $s4, $s1, $s2
    subi $s4, $s4, 1
    srlv $s4, $s0, $s4
    andi $s4, $s4, 1
    addi $s2, $s2, 1
    beq $s3, $s4, res_check_begin
    sw $zero, palindrome #fail
    j res_end
res_check_success:
    ori $s0, $zero, 1
    sw $s0, palindrome
    j res_end
res_type_1:
    j res_end
res_type_2:
    lw $s0, nums
    lw $s1, nums + 4
    and $s0, $s1, $s0
    sw $s0, seg_num
    j res_end
res_type_3:
    lw $s0, nums
    lw $s1, nums + 4
    or $s0, $s1, $s0
    sw $s0, seg_num
    j res_end
res_type_4:
    lw $s0, nums
    lw $s1, nums + 4
    xor $s0, $s1, $s0
    sw $s0, seg_num
    j res_end
res_type_5:
    lw $s0, nums
    lw $s1, nums + 4
    sllv $s0, $s0, $s1
    sw $s0, seg_num
    j res_end
res_type_6:
    lw $s0, nums
    lw $s1, nums + 4
    srlv $s0, $s0, $s1
    sw $s0, seg_num
    j res_end
res_type_7:
    lw $s0, nums
    lw $s1, nums + 4
    srav $s0, $s0, $s1
    sw $s0, seg_num
    j res_end
res_end:
    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    lw $s3, 12($sp)
    lw $s4, 16($sp)
    lw $s5, 20($sp)
    addiu $sp, $sp, 24
    jr $ra