#GPIOA: red and yellow leds
#GPIOB: switch 0-15
#GPIOC: seg7
#GPIOD: button
#GPIOE: keyboard
#GPIOF: none

.data
	cnt: .word 0
    res_type_3_cnt: .word 0
    res_type_3_flag: .word 0
	# flag: .word 0
	io_start: .word 0xfffffc00

	seg_cnt: .word 7
	seg_num: .word 0
    seg: .word 192 249 164 176 153 146 130 248 128 144 136 131 198 161 134 142

    btn_debounce: .word 0

    keyboard_now: .word 0

    arr0: .word 0 0 0 0 0 0 0 0 0 0
    arr1: .word 0 0 0 0 0 0 0 0 0 0
    arr2: .word 0 0 0 0 0 0 0 0 0 0
    arr3: .word 0 0 0 0 0 0 0 0 0 0
    length: .word 0
    now: .word 0
    
    tgt_arr: .word 0
    tgt_num: .word 0
    test_en: .word 0
    prev_test_en: .word 0
    type: .word 0
	
.text
start:
	lw $fp, io_start
	ori $s5, $zero, 5 # set t0 000101
	sw $s5, 32($fp)
    ori $s5, $zero, 26 # set exti to 011010
    sw $s5, 36($fp)
	
loop: j loop
	
systick_handler:
    # led
    
    lw $s1, now
    ori $s0, $s1, 0 #1-4: now
    lw $s1, test_en
    sll $s1, $s1, 4 #5: test_en
    or $s0, $s0, $s1
    lw $s1, type
    sll $s1, $s1, 5 #6-7: type 
    or $s0, $s0, $s1
    lw $s1, length
    sll $s1, $s1, 7 #8-11: len
    or $s0, $s0, $s1

    sw $s0, 0($fp)

    lw $s0 test_en
    bne $s0, $zero, is_not_input
    lw $s1, seg_num
    lui $s0, 0xffff
    ori $s0, $s0, 0xfff0
    and $s1, $s1, $s0
    lw $s0, keyboard_now
    or $s0, $s1, $s0
    sw $s0, seg_num
is_not_input:

    lw $s0, prev_test_en
    lw $s1, test_en
    sltu $s0, $s0, $s1 # test > prev ? 1 : 0
    beq $s0, $zero, test_not_posedge
    jal sort
test_not_posedge:
    lw $s1, test_en
    sw $s1, prev_test_en

    jal update_seg
    jal update_result

	lw $s0, cnt
	addi $s0, $s0, 1
	sw $s0, cnt
	ori $s1, $zero, 500
	bne $s1, $s0, after_check
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
    addiu $sp, $sp, -8
    sw $s0, 0($sp)
    sw $s1, 4($sp)

    lw $s0, 4($fp)

    andi $s1, $s0, 1
    sw $s1, test_en

    andi $s1, $s0, 6
    srl $s1, $s1, 1
    sw $s1, type

    andi $s1, $s0, 24
    srl $s1, $s1, 3
    sw $s1, tgt_arr

    andi $s1, $s0, 480
    srl $s1, $s1, 5
    sw $s1, tgt_num

    lw $s0, 0($sp)
    lw $s1, 4($sp)
    addiu $sp, $sp, 8
    eret

# button
exti3_handler:
    addiu $sp, $sp, -12
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    lw $s2, 8($sp)
    lw $s0, btn_debounce
    bne $s0, $zero, exti3_debounced
    lw $s0, test_en
    bne $s0, $zero, exti3_debounced

    lw $s0, 12($fp)
    ori $s1, $zero, 1
    beq $s0, $s1, exti3_right # right 00001
    ori $s1, $zero, 2
    beq $s0, $s1, exti3_left # left 00010
    ori $s1, $zero, 4
    beq $s0, $s1, exti3_up # left 00100
    ori $s1, $zero, 8
    beq $s0, $s1, exti3_confirm # conf 01000
    ori $s1, $zero, 16
    beq $s0, $s1, exti3_down # left 10000
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
exti3_up:
    lw $s0, now
    lw $s1, seg_num
    sll $s2, $s0, 2
    sw $s1, arr0($s2)
    sw $s1, arr1($s2)
    sw $s1, arr3($s2)
    # cast to 2's complement
    srl $s2, $s1, 7 # sign bit
    andi $s2, $s2, 1 # leave sign only
    beq $s2, $zero, exti3_up_positive
    sll $s2, $s2, 7
    nor $s1, $s1, $zero # s1 = ~s1
    andi $s1, $s1, 127 # s1 &= 0b1111111
    or $s1, $s1, $s2 
    addi $s1, $s1, 1
exti3_up_positive:
    sll $s2, $s0, 2
    sw $s1, arr2($s2)

    ori $s1, $zero, 9
    beq $s0, $s1, exti3_up_full
    addi $s0, $s0, 1
    sw $s0, now
    lw $s1, length
    slt $s1, $s1, $s0 # s1 = now < length ? 1 : 0
    beq $s1, $zero, exti3_up_max
    sw $s0, length
    j exti3_up_max
exti3_up_full:
    addi $s0, $s0, 1
    sw $s0, length
exti3_up_max:
    sll $s2, $s0, 2
    lw $s1, arr0($s2)
    sw $s1, seg_num
    sll $s1, $s1, 28
    srl $s1, $s1, 28
    sw $s1, keyboard_now
    j exti3_end
    
exti3_down:
    lw $s0, now
    beq $s0, $zero, exti3_end
    subi $s0, $s0, 1
    sw $s0, now
    sll $s2, $s0, 2
    lw $s1, arr0($s2)
    sw $s1, seg_num
    sll $s1, $s1, 28
    srl $s1, $s1, 28
    sw $s1, keyboard_now
    j exti3_end

exti3_confirm:
    sw $zero, seg_num
    sw $zero, keyboard_now
    sw $zero, now
    sw $zero, length
    j exti3_end

exti3_end:
    ori $s0, $zero, 1
    sw $s0, btn_debounce
exti3_debounced:
    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    addiu $sp, $sp, 12
    eret

# keyboard
exti4_handler:
    addiu $sp, $sp, -4
    sw $s0, 0($sp)
    lw $s0 test_en
    bne $s0, $zero, exti4_is_not_input

	lw $s0, 16($fp)
	sw $s0, keyboard_now

exti4_is_not_input:
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
    addiu $sp, $sp, -12
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)

    lw $s0, test_en
    beq $s0, $zero, res_end # test off

    lw $s0, type
    ori $s1, $zero, 0
    beq $s0, $s1, res_type_0
    ori $s1, $zero, 1
    beq $s0, $s1, res_type_1
    ori $s1, $zero, 2
    beq $s0, $s1, res_type_2
    ori $s1, $zero, 3
    beq $s0, $s1, res_type_3
    j res_end

res_type_0:
    lw $s0, length
    subu $s0, $s0, 1
    sll $s0, $s0, 2
    lw $s0, arr1($s0)
    lw $s1, arr1
    subu $s0, $s0, $s1
    sw $s0, seg_num
    j res_end
res_type_1:
    lw $s0, length
    subu $s0, $s0, 1
    sll $s0, $s0, 2
    lw $s0, arr3($s0)
    lw $s1, arr3
    addu $s0, $s0, $s1
    sw $s0, seg_num
    j res_end
res_type_2:
    lw $s0, tgt_arr
    lw $s2, tgt_num
    sll $s2, $s2, 2
    beq $s0, $zero, res_type2_0
    ori $s1, $zero, 1
    beq $s0, $s1, res_type2_1
    ori $s1, $zero, 2
    beq $s0, $s1, res_type2_2
    ori $s1, $zero, 3
    beq $s0, $s1, res_type2_3
    j res_end
res_type2_0:
    lw $s0, arr0($s2)
    j res_type2_end
res_type2_1:
    lw $s0, arr1($s2)
    j res_type2_end
res_type2_2:
    lw $s0, arr2($s2)
    j res_type2_end
res_type2_3:
    lw $s0, arr3($s2)
    j res_type2_end
res_type2_end:
    # output arr, num, real_num
    lw $s1, tgt_arr
    sll $s1, $s1, 28
    or $s0, $s1, $s0
    lw $s1, tgt_num
    sll $s1, $s1, 20
    or $s0, $s1, $s0
    sw $s0 seg_num
    j res_end
res_type_3:
    lw $s0, res_type_3_flag
    lw $s1, tgt_num
    sll $s1, $s1, 2
    beq $s0, $zero, res_type_3_arr0
    lw $s0, arr2($s1)
    ori $s1, $zero, 2
    j res_type_3_flag_end
res_type_3_arr0:
    lw $s0, arr0($s1)
    ori $s1, $zero, 0
res_type_3_flag_end: # s0 = real_num, s1 = 0 or 2
    sll $s1, $s1, 28
    or $s0, $s1, $s0
    lw $s1, tgt_num
    sll $s1, $s1, 20
    or $s0, $s1, $s0
    sw $s0 seg_num

    lw $s0, res_type_3_cnt # change flag
	addi $s0, $s0, 1
	sw $s0, res_type_3_cnt
	ori $s1, $zero, 5000
	bne $s1, $s0, res_end
	sw $zero, res_type_3_cnt
	lw $s0, res_type_3_flag
    slti $s0, $s0, 1 # s0 < 1, means s0 = 0
    sw $s0, res_type_3_flag
    j res_end
res_end:
    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    addiu $sp, $sp, 12
    jr $ra

sort:
    addiu $sp, $sp, -24
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s7, 8($sp)
    sw $s2, 12($sp)
    sw $s3, 16($sp)
    sw $s4, 20($sp)
    # sort arr1
    ori $s0, $zero, 1 # int i = 1
    lw $s7, length # n
sort_loop_arr1_out_start:
    ori $s1, $s0, 0 # int j = i
sort_loop_arr1_in_start:
    addiu $s2, $s1, -1 # s2 = j - 1
    sll $s2, $s2, 2
    lw $s2, arr1($s2) # s2 = arr1[j - 1]
    sll $s3, $s1, 2
    lw $s3, arr1($s3) # s3 = arr1[j]
    slt $s4, $s3, $s2 # if arr1[j - 1] < arr1[j], s4 = 1
    beq $s4, $zero, sort_loop_arr1_not_less

    addiu $s4, $s1, -1 # s4 = j - 1
    sll $s4, $s4, 2
    sw $s3, arr1($s4) # arr1[j - 1] = arr1[j]
    sll $s4, $s1, 2
    sw $s2, arr1($s4) # arr1[j] = arr1[j - 1]
sort_loop_arr1_not_less:
    addiu $s1, $s1, -1 # j--
    bne $s1, $zero, sort_loop_arr1_in_start # j != 0

    addi $s0, $s0, 1 # i++
    bne $s0, $s7, sort_loop_arr1_out_start # i != n

    #sort arr3
    ori $s0, $zero, 1 # int i = 1
sort_loop_arr3_out_start:
    ori $s1, $s0, 0 # int j = i
sort_loop_arr3_in_start:
    addiu $s2, $s1, -1 # s2 = j - 1
    sll $s2, $s2, 2
    lw $s2, arr3($s2) # s2 = arr3[j - 1]
    sll $s3, $s1, 2
    lw $s3, arr3($s3) # s3 = arr3[j]

    srl $t0, $s3, 7 # t0 = s3_sign
    andi $t0, $t0, 1
    srl $t1, $s2, 7 # t1 = s2_sign
    andi $t1, $t1, 1
    slt $s4, $t1, $t0 # s3_sign > s2_sign ? 1 : 0
    bne $s4, $zero, sort_arr3_cmp_fin
    slt $s4, $t0, $t1 # s2_sign > s3_sign ? 1 : 0
    bne $s4, $zero, sort_arr3_cmp_fail
    # s3_sign == s2_sign
    ori $s4, $t0, 0 # s4 = sign
    andi $t0, $s3, 127 # t0 = s3_abs
    andi $t1, $s2, 127 # t1 = s2_abs
    slt $t0, $t0, $t1 # t0 = s2_abs > s3_abs
    xor $s4, $t0, $s4
    j sort_arr3_cmp_fin
sort_arr3_cmp_fail:
    ori $s4, $zero, 0
sort_arr3_cmp_fin:
    beq $s4, $zero, sort_loop_arr3_not_less

    addiu $s4, $s1, -1 # s4 = j - 1
    sll $s4, $s4, 2
    sw $s3, arr3($s4) # arr1[j - 1] = arr1[j]
    sll $s4, $s1, 2
    sw $s2, arr3($s4) # arr1[j] = arr1[j - 1]
sort_loop_arr3_not_less:
    addiu $s1, $s1, -1 # j--
    bne $s1, $zero, sort_loop_arr3_in_start # j != 0

    addi $s0, $s0, 1 # i++
    bne $s0, $s7, sort_loop_arr3_out_start # i != n

    # cast arr3 to 2's complement
    ori $s0, $zero, 0
sort_loop_casting:
    sll $s3, $s0, 2
    lw $s1, arr3($s3)
    srl $s2, $s1, 7 # sign bit
    andi $s2, $s2, 1 # leave sign only
    beq $s2, $zero, sort_casting_positive
    sll $s2, $s2, 7
    nor $s1, $s1, $zero # s1 = ~s1
    andi $s1, $s1, 127 # s1 &= 0b1111111
    or $s1, $s1, $s2 
    addi $s1, $s1, 1
sort_casting_positive:
    sw $s1, arr3($s3)

    addi $s0, $s0, 1
    bne $s0, $s7, sort_loop_casting

    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $s7, 8($sp)
    lw $s2, 12($sp)
    lw $s3, 16($sp)
    lw $s4, 20($sp)
    addiu $sp, $sp, 24
    jr $ra
