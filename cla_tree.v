`timescale 1ns / 1ps

module cla_tree #(parameter N = 8)(
    input [N-1:0] a, b,
    input cin,          
    output [N-1:0] sum,
    output cout
    );
    
    wire [N-1:0] p, g, c; 
    wire [3:0] P_w1, G_w1, c_w1;
    wire [1:0] P_w2, G_w2, c_w2;  
    wire P_w3, G_w3;
    
    
    genvar i;
    
    // Instantiate a block
    generate
        for(i=0; i<8; i=i+1)begin
            ablock ab(a[i], b[i], c[i], sum[i], p[i], g[i]);
        end
    endgenerate
    
    // Instantiate b block
    bblock bb0(p[0], g[0], p[1], g[1], c_w1[0], P_w1[0], G_w1[0], c[0], c[1]);
    bblock bb1(p[2], g[2], p[3], g[3], c_w1[1], P_w1[1], G_w1[1], c[2], c[3]);
    bblock bb2(p[4], g[4], p[5], g[5], c_w1[2], P_w1[2], G_w1[2], c[4], c[5]);
    bblock bb3(p[6], g[6], p[7], g[7], c_w1[3], P_w1[3], G_w1[3], c[6], c[7]);
    
    bblock bb4(P_w1[0], G_w1[0], P_w1[1], G_w1[1], c_w2[0], P_w2[0], G_w2[0], c_w1[0], c_w1[1]);
    bblock bb5(P_w1[2], G_w1[2], P_w1[3], G_w1[3], c_w2[1], P_w2[1], G_w2[1], c_w1[2], c_w1[3]);
    
    bblock bb6(P_w2[0], G_w2[0], P_w2[1], G_w2[1], cin, P_w3, G_w3, c_w2[0], c_w2[1]);
    
    assign cout = G_w3 | (P_w3 & cin);
    
endmodule
