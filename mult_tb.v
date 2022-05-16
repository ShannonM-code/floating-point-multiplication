`timescale 1ns / 1ps

module mult_tb();
    parameter N = 32, M = 64;
    //Inputs
    reg clk, rst;
    reg [M-1:0] data;
    
    //Outputs
    wire [N-1:0] p;
    
    fsm i0(clk, rst, data, p);
                                    
    initial begin
        clk = 0;
        rst = 0;
        end
        
     always begin
        #5 clk = ~clk;
        end
        
     always @(posedge clk) begin
        rst = 1; #5
        rst = 0;
        data = 64'h4159999ac0e9999a; #70
        rst = 1; #5
        rst = 0;
        data = 64'hc8de71efd980c912; #70 
        rst = 1; #5
        rst = 0;
        data = 64'h7f468f5c7f06bf7c; # 70
        rst = 1; #5
        rst = 0;
        data = 64'h0080000100800002; # 70 
        rst = 1; #5
        rst = 0;
        data = 64'h15eadf51ff800000; # 70
        $monitor ("a = %0h \tb = %0h \tp = %0h", data[63:32], data[31:0], p);
        
        end
        
 
endmodule
