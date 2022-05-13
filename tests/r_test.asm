.data  0x0000
   buf:   .word  0x00000055, 0x000000AA
.text 0x0000
start:
# Please make sure ori, sw for io and lui are working properly
        # lui, ori and sw for io
        lui $s0, 1
        ori $s0, $s0, 0xBF52
        lui $s7, 0xFFFF
        ori $s7, $s7, 0xFC00
        sw $s0, 0($s7) # seg should be 114514

        lui $s1, 0xFFE2
        ori $s1, $s1, 0xB4BE
        sw $s1, 0($s7) # seg should be -1919810

        # sll
        sll $s2, $s0, 9
        sw $s2, 0($s7) # seg should be 58631168

        # srl
        srl $s2, $s2, 9
        sw $s2, 0($s7) # seg should be 114514

        # sllv
        ori $t0, $zero, 6
        sllv $s2, $s2, $t0
        sw $s2, 0($s7) # seg should be 7328896

        # srlv
        srlv $s2, $s2, $t0
        sw $s2, 0($s7) # seg should be 114514

        # sra
        sra $s2, $s1, 5
        sw $s2, 0($s7) # seg should be -59995 fail
        sra $s2, $s0, 5
        sw $s2, 0($s7) # seg should be 3578

        # srav
        srav $s2, $s1, $t0
        sw $s2, 0($s7) # seg should be -29998 fail
        srav $s2, $s0, $t0
        sw $s2, 0($s7) # seg should be 1789

        # add, without overflow
        add $s2, $s0, $s0
        sw $s2, 0($s7) # seg should be 229028
        add $s2, $s1, $s0
        sw $s2, 0($s7) # seg should be -1805296

        # addu
        addu $s2, $s0, $s0
        sw $s2, 0($s7) # seg should be 229028
        addu $s2, $s1, $s0
        sw $s2, 0($s7) # seg should be -1805296

        # sub, without overflow
        sub $s2, $s0, $s0
        sw $s2, 0($s7) # seg should be 0
        sub $s2, $s1, $s0
        sw $s2, 0($s7) # seg should be -2034324

        # subu
        subu $s2, $s1, $s1
        sw $s2, 0($s7) # seg should be 0
        subu $s2, $s0, $s1
        sw $s2, 0($s7) # seg should be 2034324

        # and
        and $s2, $s1, $s0
        sw $s2, 0($s7) # seg should be 46098

        # or
        or $s2, $s1, $s0
        sw $s2, 0($s7) # seg should be -1851394

        # xor
        xor $s2, $s1, $s0
        sw $s2, 0($s7) # seg should be -1897492

        # nor
        nor $s2, $s1, $s0
        sw $s2, 0($s7) # seg should be 46081 fail actual 1851393

        # slt
        sub $t1, $zero, $t0
        slt $s2, $s0, $t0
        sw $s2, 0($s7) # seg should be 0

        slt $s2, $t0, $s0
        sw $s2, 0($s7) # seg should be 1

        slt $s2, $s1, $t0
        sw $s2, 0($s7) # seg should be 1

        slt $s2, $t0, $s1
        sw $s2, 0($s7) # seg should be 0

        slt $s2, $s1, $t1
        sw $s2, 0($s7) # seg should be 1

        slt $s2, $t1, $s1
        sw $s2, 0($s7) # seg should be 0

        # sltu
        sltu $s2, $s0, $t0
        sw $s2, 0($s7) # seg should be 0

        sltu $s2, $t0, $s0
        sw $s2, 0($s7) # seg should be 1

        sltu $s2, $s1, $t0
        sw $s2, 0($s7) # seg should be 0

        sltu $s2, $t0, $s1
        sw $s2, 0($s7) # seg should be 1
