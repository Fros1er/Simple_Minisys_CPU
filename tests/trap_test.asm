.text 0x0000
start:
        lui $s7, 0xFFFF
        ori $s7, $s7, 0xFC00
        ori $s5, $zero, 114
        ori $s6, $zero, 514

        # teq
        sw $s5, 0($s7)
        teq $zero, $zero # seg should be 114, then 514

        sw $s5, 0($s7)
        teq $s6, $zero # seg should be 114
        
        # tne
        sw $s5, 0($s7)
        teq $zero, $zero # seg should be 114

        sw $s5, 0($s7)
        teq $s6, $zero # seg should be 114, then 514

        # teqi
        sw $s5, 0($s7)
        teqi $zero, 0 # seg should be 114, then 514

        sw $s5, 0($s7)
        teqi $zero, 1 # seg should be 114
        
        # tne
        sw $s5, 0($s7)
        tnei $zero, 0 # seg should be 114

        sw $s5, 0($s7)
        tnei $zero, 1 # seg should be 114, then 514

end:    j end

systick_handler:
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
        