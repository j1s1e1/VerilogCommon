`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/25/2020 07:29:47 PM
// Design Name: 
// Module Name: accum_add_sub
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


module accum_add_sub
#(parameter BITS = 32, PRECISION ="SINGLE")
(
input clk,
input in_valid,
input [BITS-1:0] a,
input [BITS-1:0] b,
input [BITS-1:0] c,
output out_valid,
output [BITS-1:0] d
);

if (PRECISION == "INT8")
int8_accum_add_sub int8_accum_add_sub1
(
.clk,
.in_valid,
.a,
.b,
.c,
.out_valid,
.d
);

if (PRECISION == "SINGLE")
single_accum_add_sub single_accum_add_sub1
(
.clk,
.in_valid,
.a,
.b,
.c,
.out_valid,
.d
);

if (PRECISION == "COMPLEX_SINGLE")
complex_single_accum_add_sub complex_single_accum_add_sub1
(
.clk,
.in_valid,
.a,
.b,
.c,
.out_valid,
.d
);

endmodule
