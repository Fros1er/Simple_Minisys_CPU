.text 0x0000
start:

loop_begin: nop
loop_end: j loop_begin

systick_handler:
	teq $zero, $zero
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
        
        
