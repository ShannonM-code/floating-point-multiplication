module booth_enc(b, m, pp);
    parameter N = 32;
    parameter M = 64;
    input [2:0] b;
    input [N-1:0] m;
    output reg [M-1:0] pp;
   
    always@ * begin
        case(b) 
            3'b000: pp <= 64'b0;
            3'b001: pp <= m; 
            3'b010: pp <= m; 
            3'b011: pp <= m << 1; 
            3'b100: pp <= -(m << 1); 
            3'b101: pp <= -m; 
            3'b110: pp <= -m; 
            3'b111: pp <= 64'b0; 
        endcase
            
    end 

endmodule