`timescale 1ns / 1ps

module multiplier(clk, rst, data, p);
    parameter N = 32, M = 64;
    input clk, rst;
    input [M-1:0] data;
    output reg [N-1:0] p;
    
    //reg [N-1:0] a, b;
    reg [2:0] state, nextstate;
    reg [N-1:0] a_mant, b_mant;  // temporary mantissa for multiplication
    reg [22:0] mantissa;  // Final mantissa
    reg [7:0] a_exp, b_exp, exponent;  // exponents for a and b, final exponent
    reg p_sign;  // Final sign
    reg [7:0] bias = 8'h7f;  // Bias that is used to subtract from added exponents
    
    //reg start;
    reg [7:0] exponent_temp;  // temporary exponent for subtracting bias
    reg [M-1:0] mantissa_product; // product of multipllying mantissa
    reg cin = 0;
    
    wire round_bit, sticky_bit, msb_s;  // Sticky bit, round bit, and msb of sticky bits
    wire [7:0] exponent_temp_w1, exponent_temp_w2;  // temporary wires for exponents for calculations
    wire [M-1:0] mantissa_product_w1;  // wire for calculations
    wire [22:0] mantissa_product_w2;  // mantissa after rounding and truncation
    wire carry_bit1, carrybit2;
    
    // Add exponents, subtract bias
    cla_tree i0(a_exp, b_exp, cin, exponent_temp_w1, carry_bit1);
    sub i1(exponent_temp, bias, exponent_temp_w2, overflow);
    
    // Multiply mantissas
    wallace_tree_32_bit i2(a_mant, b_mant, mantissa_product_w1);
    
    // Get sticky/round bits
    round_sticky i3(mantissa_product, round_bit, sticky_bit, msb_s, mantissa_product_w2);
    
    // Check corner case
    // INF: exponent = 11111111
    // Overflow: exponent = 11111111 after calculations
    // NaN: exponent all 1, mantissa not zero
    
    parameter 
        IDLE = 3'b000,
        START = 3'b001,
        CORNER = 3'b010,
        FLOW = 3'b011,
        ADD = 3'b100,     
        MULT = 3'b101,
        ROUND = 3'b110,
        DONE = 3'b111;
        
     always @(posedge clk or posedge rst) begin
        if(rst) 
            state <= IDLE;
        else
            state <= nextstate; end
     
     always @(state) begin
        case(state)
            IDLE: begin
                p_sign = 0;
                a_exp = 0;
                b_exp = 0;
                a_mant = 0;
                b_mant = 0;
                nextstate = START; end
             
            START: begin
                p_sign = data[63] ^ data[31];  
                a_exp = data[62:55];        
                b_exp = data[30:23];        
                a_mant = {1'b1, data[54:32]};
                b_mant = {1'b1, data[22:0]};
                nextstate = CORNER; end
                
            CORNER: begin
                // Special Values
                if((a_exp == 8'hFF && a_mant == 23'h0) || (b_exp == 8'hFF && b_mant == 23'h0)) begin
                    // Represents infinity. Can be negative or positive
                    exponent = 8'hFF;  // All 1's
                    mantissa = 23'h7FFFFF;  // All 1's
                    nextstate = DONE;
                    end
                else if((a_exp == 8'hFF && a_mant != 0) || (b_exp == 8'hFF && b_mant != 0)) begin
                    // Represents infinity when mantissa's are greater than 0
                    exponent = 8'hFF;  // All 0's
                    mantissa = 23'h7FFFFF;  // All 0's
                    nextstate = DONE; 
                    end   
                // Denormalized
                else if((a_exp == 8'h00 && a_mant == 23'h0) || (b_exp == 8'h00 && b_mant == 23'h0)) begin
                    // Represents zero. Can be negative.
                    p_sign = 0;
                    exponent = 0;
                    mantissa = 0;
                    nextstate = DONE; 
                    end
                else if((a_exp == 8'h00 && a_mant != 0) || (b_exp == 8'h00 && b_mant != 0)) begin
                    // Numbers very close to zero. 
                    // Loses preceision as they get smaller -> gradual underflow
                    p_sign = 0;
                    exponent = 0;
                    mantissa = 0;
                    nextstate = DONE; 
                    end
                else  
                    nextstate = FLOW; end  
                    
            FLOW: begin 
                // Underflow
                if({carry_bit1, exponent_temp_w1} < 8'h7E) begin
                    p_sign = 0;
                    exponent = 0;
                    mantissa = 0;
                    nextstate = DONE; end
                // Overflow
                else if({carry_bit1, exponent_temp_w1} > 9'h17F) begin
                    exponent = 8'hFF;  // All 1's
                    mantissa = 23'h7FFFFF;  // All 1's
                    nextstate = DONE; end
                else
                    nextstate = ADD; end
                    
            ADD: begin
                exponent_temp = exponent_temp_w1;
                mantissa_product = mantissa_product_w1;
                nextstate = MULT; end
                
            MULT: begin
                if(mantissa_product_w1[47]) begin
                    exponent = exponent_temp_w2 + 1'b1;
                    nextstate = ROUND; end
                else begin
                    exponent = exponent_temp_w2 - 1'b1;
                    nextstate = ROUND; end end
                
            ROUND: begin
                if(p_sign == 0 && (round_bit | sticky_bit))  
                    mantissa = mantissa_product_w2 + 1'b1;
                else
                    mantissa = mantissa_product_w2;
                nextstate = DONE; end
                                            
            DONE: begin
                p = {p_sign, exponent, mantissa}; 
                nextstate = IDLE; end
            endcase
        end

endmodule