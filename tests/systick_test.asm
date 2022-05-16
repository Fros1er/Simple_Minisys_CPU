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

.text 0x4180
        sw $s6, 0($s7) 
        mfc0 $k0,$14
        addi $k0,$k0,4
        mtc0 $k0,$14
        eret