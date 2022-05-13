.data  0x0000
   buf:   .word  114514, -1919810
.text 0x0000
start:
      lui $s7, 0xFFFF
      ori $s7, $s7, 0xFC00
      
      # lw data
      ori $t0, $zero, 0
      lw $s0, 0($t0)
      sw $s0, 0($s7) # seg should be 114514
      lw $s1, 4($t0)
      sw $s1, 0($s7) # seg should be -1919810

      # lw io
      lw $s2, 0($s7)
      sw $s0, 0($s7) # seg should be 114514
      sw $s2, 0($s7) # seg should be -1919810

      # sw mem
      sw $s0, 8($t0)
      lw $s2, 8($t0)
      sw $s2, 0($s7) # seg should be 114514

      # addi, without overflow
      addi $s2, $s0, -114
      sw $s2, 0($s7) # seg should be 114400
      addi $s2, $s1, 514
      sw $s2, 0($s7) # seg should be -1919296

      # addiu
      addiu $s2, $s0, -114
      sw $s2, 0($s7) # seg should be 114400
      addiu $s2, $s1, 514
      sw $s2, 0($s7) # seg should be -1919296

      # slti
      ori $t1, $zero, 6
      sub $t2, $zero, $t1

      slti $s2, $s0, 114
      sw $s2, 0($s7) # seg should be 0

      slti $s2, $t1, 114
      sw $s2, 0($s7) # seg should be 1

      slti $s2, $t2, -114
      sw $s2, 0($s7) # seg should be 0

      slti $s2, $t2, -1
      sw $s2, 0($s7) # seg should be 1

      slti $s2, $s0, -1
      sw $s2, 0($s7) # seg should be 0

      slti $s2, $t2, 114
      sw $s2, 0($s7) # seg should be 1

      # sltiu
      sltiu $s2, $s0, 114
      sw $s2, 0($s7) # seg should be 0

      sltiu $s2, $t1, 114
      sw $s2, 0($s7) # seg should be 1

      # andi
      andi $s2, $s0, 114
      sw $s2, 0($s7) # seg should be 82

      # xori
      xori $s2, $s0, 114
      sw $s2, 0($s7) # seg should be 114464
