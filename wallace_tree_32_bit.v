module wallace_tree_32_bit (q, m, p);
    parameter A = 32, B = 64, C = 16, D = 14;
    input [A-1:0] q, m;
    output [B-1:0] p;
    
    reg [A-1:0] m_w, q_w;
    
    wire [2:0] bits[C-1:0];
    wire [B-1:0] pp_w[C-1:0];
    wire [B-1:0] sum[D-1:0], car[D-1:0];
    
    always @(m) begin
        if(m < 0)
            m_w = ~m + 1;
        else
            m_w = m; 
            end
            
   // Assign first bits
    assign bits[0][2:0] = {q[1:0], {1'b0}};
//    assign bits[1][2:0] = q[3:1];
//    assign bits[2][2:0] = q[5:3];
//    assign bits[3][2:0] = q[7:5];
//    assign bits[4][2:0] = q[9:7];
//    assign bits[5][2:0] = q[11:9];
//    assign bits[6][2:0] = q[13:11];
//    assign bits[7][2:0] = q[15:13];
    
    
    genvar i;
    // Generate bits for encoding
    generate
        for(i = 1; i < C; i = i + 1) begin
            assign bits[i] = q[2*i+1:2*i-1]; end
    endgenerate
    
    // Get partial products
    generate 
        for(i = 0; i < C; i = i + 1) begin
            booth_enc u(bits[i], m_w, pp_w[i]); end
    endgenerate
    
    // Instantiate CSA's
    csa #(64) c00(pp_w[0], {pp_w[1], 2'b0}, {pp_w[2], 4'b0}, sum[0], car[0]);
    csa #(64) c01({pp_w[3], 6'b0}, {pp_w[4], 8'b0}, {pp_w[5], 10'b0}, sum[1], car[1]);       
    csa #(64) c02({pp_w[6], 12'b0}, {pp_w[7], 14'b0}, {pp_w[8], 16'b0}, sum[2], car[2]);
    csa #(64) c03({pp_w[9], 18'b0}, {pp_w[10], 20'b0}, {pp_w[11], 22'b0}, sum[3], car[3]);
    csa #(64) c04({pp_w[12], 24'b0}, {pp_w[13], 26'b0}, {pp_w[14], 28'b0}, sum[4], car[4]);
    csa #(64) c05(sum[0], car[0], sum[1], sum[5], car[5]);
    csa #(64) c06(car[1], sum[2], car[2], sum[6], car[6]);
    csa #(64) c07(sum[3], car[3], sum[4], sum[7], car[7]);
    csa #(64) c08(sum[5], car[5], sum[6], sum[8], car[8]);
    csa #(64) c09(car[6], sum[7], car[7], sum[9], car[9]);
    csa #(64) c10(sum[8], car[8], sum[9], sum[10], car[10]);
    csa #(64) c11({pp_w[15], 30'b0}, car[9], car[4], sum[11], car[11]);
    csa #(64) c12(sum[10], car[10], sum[11], sum[12], car[12]);
    csa #(64) c13(sum[12], car[12], car[11], sum[13], car[13]);
    
    reg cin = 0;
    wire cout;

    cpa_64_bit i0(sum[13], car[13], cin, p, cout);    
    
endmodule