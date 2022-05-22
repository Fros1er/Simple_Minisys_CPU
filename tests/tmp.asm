exti3_handler:                          
	addiu	$sp, $sp, -16
	
	sw	$4, 8($sp)
    lw $4, 12($fp)
    ori	$1, $zero, $4
	lw	$4, 8($sp)

	addiu	$2, $zero, 40
	sw	$1, 0($sp)              
	bne	$4, $2, $BB0_3
	j	$BB0_2
$BB0_2:
	sw	$zero, 4($sp)
	j	$BB0_63
$BB0_3:
	lw	$1, 8($sp)
	addiu	$2, $zero, 17
	bne	$1, $2, $BB0_6
	j	$BB0_5
$BB0_5:
	addiu	$1, $zero, 1
	sw	$1, 4($sp)
	j	$BB0_62
$BB0_6:
	lw	$1, 8($sp)
	addiu	$2, $zero, 33
	bne	$1, $2, $BB0_9
	j	$BB0_8
$BB0_8:
	addiu	$1, $zero, 2
	sw	$1, 4($sp)
	j	$BB0_61
$BB0_9:
	lw	$1, 8($sp)
	addiu	$2, $zero, 65
	bne	$1, $2, $BB0_12
	j	$BB0_11
$BB0_11:
	addiu	$1, $zero, 3
	sw	$1, 4($sp)
	j	$BB0_60
$BB0_12:
	lw	$1, 8($sp)
	addiu	$2, $zero, 18
	bne	$1, $2, $BB0_15
	j	$BB0_14
$BB0_14:
	addiu	$1, $zero, 4
	sw	$1, 4($sp)
	j	$BB0_59
$BB0_15:
	lw	$1, 8($sp)
	addiu	$2, $zero, 34
	bne	$1, $2, $BB0_18
	j	$BB0_17
$BB0_17:
	addiu	$1, $zero, 5
	sw	$1, 4($sp)
	j	$BB0_58
$BB0_18:
	lw	$1, 8($sp)
	addiu	$2, $zero, 66
	bne	$1, $2, $BB0_21
	j	$BB0_20
$BB0_20:
	addiu	$1, $zero, 6
	sw	$1, 4($sp)
	j	$BB0_57
$BB0_21:
	lw	$1, 8($sp)
	addiu	$2, $zero, 20
	bne	$1, $2, $BB0_24
	j	$BB0_23
$BB0_23:
	addiu	$1, $zero, 7
	sw	$1, 4($sp)
	j	$BB0_56
$BB0_24:
	lw	$1, 8($sp)
	addiu	$2, $zero, 36
	bne	$1, $2, $BB0_27
	j	$BB0_26
$BB0_26:
	addiu	$1, $zero, 8
	sw	$1, 4($sp)
	j	$BB0_55
$BB0_27:
	lw	$1, 8($sp)
	addiu	$2, $zero, 68
	bne	$1, $2, $BB0_30
	j	$BB0_29
$BB0_29:
	addiu	$1, $zero, 9
	sw	$1, 4($sp)
	j	$BB0_54
$BB0_30:
	lw	$1, 8($sp)
	addiu	$2, $zero, 129
	bne	$1, $2, $BB0_33
	j	$BB0_32
$BB0_32:
	addiu	$1, $zero, 10
	sw	$1, 4($sp)
	j	$BB0_53
$BB0_33:
	lw	$1, 8($sp)
	addiu	$2, $zero, 130
	bne	$1, $2, $BB0_36
	j	$BB0_35
$BB0_35:
	addiu	$1, $zero, 11
	sw	$1, 4($sp)
	j	$BB0_52
$BB0_36:
	lw	$1, 8($sp)
	addiu	$2, $zero, 132
	bne	$1, $2, $BB0_39
	j	$BB0_38
$BB0_38:
	addiu	$1, $zero, 12
	sw	$1, 4($sp)
	j	$BB0_51
$BB0_39:
	lw	$1, 8($sp)
	addiu	$2, $zero, 136
	bne	$1, $2, $BB0_42
	j	$BB0_41
$BB0_41:
	addiu	$1, $zero, 13
	sw	$1, 4($sp)
	j	$BB0_50
$BB0_42:
	lw	$1, 8($sp)
	addiu	$2, $zero, 24
	bne	$1, $2, $BB0_45
	j	$BB0_44
$BB0_44:
	addiu	$1, $zero, 14
	sw	$1, 4($sp)
	j	$BB0_49
$BB0_45:
	lw	$1, 8($sp)
	addiu	$2, $zero, 36
	bne	$1, $2, $BB0_48
	j	$BB0_47
$BB0_47:
	addiu	$1, $zero, 15
	sw	$1, 4($sp)
	j	$BB0_48
$BB0_48:
	j	$BB0_49
$BB0_49:
	j	$BB0_50
$BB0_50:
	j	$BB0_51
$BB0_51:
	j	$BB0_52
$BB0_52:
	j	$BB0_53
$BB0_53:
	j	$BB0_54
$BB0_54:
	j	$BB0_55
$BB0_55:
	j	$BB0_56
$BB0_56:
	j	$BB0_57
$BB0_57:
	j	$BB0_58
$BB0_58:
	j	$BB0_59
$BB0_59:
	j	$BB0_60
$BB0_60:
	j	$BB0_61
$BB0_61:
	j	$BB0_62
$BB0_62:
	j	$BB0_63
$BB0_63:

	lw	$2, 12($sp)
	addiu	$sp, $sp, 16
	eret

