`timescale 1ns / 1ps

module csa #(parameter N = 4)(
    input [N-1:0] x, y, z,
    output [N-1:0] sum, cout
    );
	
	assign cout[0] = 0;
    
    genvar i;
    
    generate 
        for(i=0; i<N; i=i+1)begin
            full_adder a(x[i], y[i], z[i], sum[i], cout[i+1]);
        end
    endgenerate
endmodule

