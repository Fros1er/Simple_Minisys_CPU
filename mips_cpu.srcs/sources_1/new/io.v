`timescale 1ns / 1ps

module io(
    input clk,
    input rst,
    input write_en,
    input[9:0] access_target,
    output[15:0] gpio_a, gpio_b, gpio_c, gpio_d, gpio_e, gpio_f,
    input[31:0] write_val,
    output[31:0] read_val
);
    reg[7:0] io_buffer[5:0];
    reg[31:0] exti_reg[5:0];
    
    assign gpio_a = io_buffer[0][0];
    assign gpio_b = io_buffer[1];
    assign gpio_c = io_buffer[2];
    assign gpio_d = io_buffer[3];
    assign gpio_e = io_buffer[4];
    assign gpio_f = io_buffer[5];
    
    wire test;
    assign test = gpio_a;
    
    assign read_val = (access_target[5:2] == 4'b0000) ? gpio_a :
                      (access_target[5:2] == 4'b0001) ? gpio_b :
                      (access_target[5:2] == 4'b0010) ? gpio_c :
                      (access_target[5:2] == 4'b0011) ? gpio_d :
                      (access_target[5:2] == 4'b0100) ? gpio_e :
                      (access_target[5:2] == 4'b0101) ? gpio_f :
                      (access_target[5:2] == 4'b1000) ? exti_reg[access_target[2:0]] : 0;
    
    integer i;
    always @(negedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 6; i = i + 1) begin
                    io_buffer[i] <= 0;
                end
        end
        else begin
            if (write_en) begin
                case (access_target[5])
                    0: io_buffer[access_target[4:2]] <= write_val[15:0];
                   // 1: exti_reg[access_target[4:2]] <= write_val;
                endcase
            end
        end
    end
endmodule
