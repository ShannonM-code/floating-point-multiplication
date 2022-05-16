`timescale 1ns / 1ps

module round_sticky(product, round, sticky, msb_s, mantissa);
    parameter N = 64, M = 23;
    
    input [N-1:0] product;
    output reg round, sticky, msb_s;
    output reg [M-1:0] mantissa;
    
    always @(product)
        if(product[47] == 0) begin
            mantissa <= product[45:23]; 
            round <= product[22];
            sticky <= ^product[21:0]; 
            msb_s <= product[21]; end
         else begin
            mantissa <= product[46:24];
            round <= product[23]; 
            sticky <= ^product[22:0];
            msb_s <= product[22]; end
    
endmodule
