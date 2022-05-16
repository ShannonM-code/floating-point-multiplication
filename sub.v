`timescale 1ns / 1ps

module sub #(parameter N = 8)(
    input [N-1:0] a, b, 
    output [N-1:0] r,
    output cout
);
    
    reg sub_bit = 1'b1;
    wire [N-1:0] b_neg, res;
    wire cout_w;

    // Using addition properties, a - b = a + (-b)
    // To get (-b), b is xor'd with 1 and a sign bit
    // of 1 is appended to the front
    
    // xor b with 1
    genvar i;
    
    generate
        for(i = 0; i < N; i = i + 1)
            assign b_neg[i] = b[i] ^ sub_bit; 
    endgenerate
    
    // Add
    cla_tree cla0(a, b_neg, sub_bit, res, cout_w);
    
    assign cout = ~cout_w;
    assign r = res;

endmodule