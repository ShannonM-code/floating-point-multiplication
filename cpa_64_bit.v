`timescale 1ns / 1ps

module cpa_64_bit(a, b, cin, sum, cout);
    parameter N = 64;
    input [N-1:0] a, b;
    input cin;
    output [N-1:0] sum;
    output cout;
    
    wire [14:0] c;
    
    cla_4_bit i0(a[3:0], b[3:0], cin, sum[3:0], c[0]);
    cla_4_bit i1(a[7:4], b[7:4], c[0], sum[7:4], c[1]);
    cla_4_bit i2(a[11:8], b[11:8], c[1], sum[11:8], c[2]);
    cla_4_bit i3(a[15:12], b[15:12], c[2], sum[15:12], c[3]);
    cla_4_bit i4(a[19:16], b[19:16], c[3], sum[19:16], c[4]);
    cla_4_bit i5(a[23:20], b[23:20], c[4], sum[23:20], c[5]);
    cla_4_bit i6(a[27:24], b[27:24], c[5], sum[27:24], c[6]);
    cla_4_bit i7(a[31:28], b[31:28], c[6], sum[31:28], c[7]);
    cla_4_bit i8(a[35:32], b[35:32], c[7], sum[35:32], c[8]);
    cla_4_bit i9(a[39:36], b[39:36], c[8], sum[39:36], c[9]);
    cla_4_bit i10(a[43:40], b[43:40], c[9], sum[43:40], c[10]);
    cla_4_bit i11(a[47:44], b[47:44], c[10], sum[47:44], c[11]);
    cla_4_bit i12(a[51:48], b[51:48], c[11], sum[51:48], c[12]);
    cla_4_bit i13(a[55:52], b[55:52], c[12], sum[55:52], c[13]);
    cla_4_bit il4(a[59:56], b[59:56], c[13], sum[59:56], c[14]);
    cla_4_bit i15(a[63:60], b[63:60], c[13], sum[63:60], cout);

endmodule
