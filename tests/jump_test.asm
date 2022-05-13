.data
.text 0x0000
start:
        lui $s7, 0xFFFF
        ori $s7, $s7, 0xFC00
        ori $s5, $zero, 114
        ori $s6, $zero, 514

        # jr
        ori $s0, $zero, 28
        jr $s0
        sw $s5, 0($s7)
        sw $s6, 0($s7) # seg should be 514

        # beq
        ori $s1, $zero, 28 
        beq $s0, $s1, beqtest1 # jump
        sw $s5, 0($s7)
beqtest1:sw $s6, 0($s7) # seg should be 514

        ori $s1, $zero, 15
        beq $s0, $s1, beqtest2 # no jump
        sw $s5, 0($s7)
beqtest2:sw $s6, 0($s7) # seg should be 114, then 514

        # bne
        ori $s1, $zero, 28
        bne $s0, $s1, bnetest1 # no jump
        sw $s5, 0($s7)
bnetest1:sw $s6, 0($s7) # seg should be 114, then 514

        ori $s1, $zero, 15 # jump
        bne $s0, $s1, bnetest2
        sw $s5, 0($s7)
bnetest2:sw $s6, 0($s7) # seg should be 514

        # jump
        j jmptest
        sw $s5, 0($s7)
jmptest:sw $s6, 0($s7) # seg should be 514

        # jal
        jal funct
        sw $s6, 0($s7) # seg should be 114, then 514
        j end

funct:  
        sw $s5, 0($s7) # seg should be 114
        jr $ra

end:    sw $zero, 0($s7) # seg should be 0
