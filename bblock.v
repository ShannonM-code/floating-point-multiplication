`timescale 1ns / 1ps

module bblock(
    input P_ij, G_ij, P_jk, G_jk, cin,
    output P, G, c_i, c_j
    );
    
    assign G = G_jk | (P_jk & G_ij);
    assign P = P_ij & P_jk;
    assign c_j = G_ij | (P_ij & cin);
    assign c_i = cin;
    
endmodule
