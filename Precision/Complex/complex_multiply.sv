`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/10/2020 01:23:56 PM
// Design Name: 
// Module Name: complex_multiply
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module complex_multiply
#(parameter BITS = 16, PRECISION = "SINGLE")
(
input clk,
input in_valid,
input [BITS-1:0] a,
input [BITS-1:0] b,
output out_valid,
output [BITS-1:0] c
);

logic [BITS/2-1:0] ar_x_br;
logic [BITS/2-1:0] ai_x_bi;
logic [BITS/2-1:0] ar_x_bi;
logic [BITS/2-1:0] ai_x_br;

logic out_valid_mult;

multiply
#(.BITS(BITS/2), .PRECISION(PRECISION))
multiply_ar_br
(
.rstn(1'b1),
.clk(clk),
.in_valid(in_valid),
.a(a[BITS-1:BITS/2]),
.b(b[BITS-1:BITS/2]),
.out_valid(out_valid_mult),
.c(ar_x_br)
);

multiply
#(.BITS(BITS/2), .PRECISION(PRECISION))
multiply_ar_bi
(
.rstn(1'b1),
.clk(clk),
.in_valid(in_valid),
.a(a[BITS-1:BITS/2]),
.b(b[BITS/2-1:0]),
.out_valid(),
.c(ar_x_bi)
);

multiply
#(.BITS(BITS/2), .PRECISION(PRECISION))
multiply_ai_br
(
.rstn(1'b1),
.clk(clk),
.in_valid(in_valid),
.a(a[BITS/2-1:0]),
.b(b[BITS-1:BITS/2]),
.out_valid(),
.c(ai_x_br)
);

multiply
#(.BITS(BITS/2), .PRECISION(PRECISION))
multiply_ai_bi
(
.rstn(1'b1),
.clk(clk),
.in_valid(in_valid),
.a(a[BITS/2-1:0]),
.b(b[BITS/2-1:0]),
.out_valid(),
.c(ai_x_bi)
);

subtract
#(.BITS(BITS/2), .PRECISION(PRECISION))
subtract1
(
.clk(clk),
.in_valid(out_valid_mult),
.a(ar_x_br),
.b(ai_x_bi),
.out_valid(out_valid),
.c(c[BITS-1:BITS/2])
);

add
#(.BITS(BITS/2), .PRECISION(PRECISION))
add1
(
.clk(clk),
.in_valid(out_valid_mult),
.a(ar_x_bi),
.b(ai_x_br),
.out_valid(out_valid),
.c(c[BITS/2-1:0])
);

endmodule
