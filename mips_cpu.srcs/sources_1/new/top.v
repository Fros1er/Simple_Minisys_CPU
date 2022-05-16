`timescale 1ns / 1ps

module top(
    //input sys_clk,
    //input rst
);
    reg sys_clk;
    reg rst;
    
    wire [31:0] gpio_a, gpio_b, gpio_c, gpio_d, gpio_e, gpio_f;
    
//    cpu_top cpu(
//        .sys_clk(sys_clk),
//        .rst(rst),
//        .gpio_a(gpio_a),
//        .gpio_b(gpio_b),
//        .gpio_c(gpio_c),
//        .gpio_d(gpio_d),
//        .gpio_e(gpio_e),
//        .gpio_f(gpio_f)
//    );
    
    initial begin 
        sys_clk = 0;
        rst = 1;
        #11 rst = 0;
    end
    
    always #3 sys_clk = ~sys_clk;
endmodule
