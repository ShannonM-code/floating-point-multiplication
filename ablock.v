`timescale 1ns / 1ps

module ablock(
    input a, b, cin,
    output sum, p, g
    );
    
    assign sum = a ^ b ^ cin;
    assign p = a | b;
    assign g = a & b;
    
endmodule
