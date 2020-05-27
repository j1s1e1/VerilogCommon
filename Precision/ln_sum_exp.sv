`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/02/2020 04:11:25 PM
// Design Name: 
// Module Name: ln_sum_exp
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


module ln_sum_exp
#(BITS = 16, PRECISION = "HALF", APROX_EXP = "FALSE", TABLES = 0)
(
input clk,
input in_valid,
input [BITS-1:0] a,
input [BITS-1:0] b,
output out_valid,
output [BITS-1:0] c
);

if (TABLES == 0)
ln_sum_exp_full
#(.BITS(BITS), .PRECISION(PRECISION))
ln_sum_exp_full1
(
.clk,
.in_valid,
.a,
.b,
.out_valid,
.c
);
else
ln_sum_exp_table
#(.BITS(BITS), .PRECISION(PRECISION))
ln_sum_exp_table1
(
.clk,
.in_valid,
.a,
.b,
.out_valid,
.c
);

endmodule
