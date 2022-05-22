// #GPIOA: red and yellow leds
// #GPIOB: switch 0-15
// #GPIOC: seg7
// #GPIOD: keyboard & button
// #GPIOE: 3 leds
// #GPIOF: 3 switches

#define GPIOA_READ() __asm("lw $a0, 0($fp)")
#define GPIOB_READ() __asm("lw $a0, 4($fp)")
#define GPIOC_READ() __asm("lw $a0, 8($fp)")
#define GPIOD_READ() __asm("lw $a0, 12($fp)")
#define GPIOE_READ() __asm("lw $a0, 16($fp)")
#define GPIOF_READ() __asm("lw $a0, 20($fp)")
#define GPIOA_WRITE() __asm("sw $a0, 0($fp)")
#define GPIOB_WRITE() __asm("sw $a0, 4($fp)")
#define GPIOC_WRITE() __asm("sw $a0, 8($fp)")
#define GPIOD_WRITE() __asm("sw $a0, 12($fp)")
#define GPIOE_WRITE() __asm("sw $a0, 16($fp)")
#define GPIOF_WRITE() __asm("sw $a0, 20($fp)")

int exti3_handler(int in) {
    int res;
    if (in == 40) res = 0;
    else if (in == 17) res = 1;
    else if (in == 33) res = 2;
    else if (in == 65) res = 3;
    else if (in == 18) res = 4;
    else if (in == 34) res = 5;
    else if (in == 66) res = 6;
    else if (in == 20) res = 7;
    else if (in == 36) res = 8;
    else if (in == 68) res = 9;
    else if (in == 129) res = 10;
    else if (in == 130) res = 11;
    else if (in == 132) res = 12;
    else if (in == 136) res = 13;
    else if (in == 24) res = 14;
    else if (in == 36) res = 15;
}

          
