`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/13/2020 06:47:13 PM
// Design Name: 
// Module Name: log2_table_one_to_two
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


module log2_table_one_to_two
#(BITS = 16, PRECISION = "HALF", STEPS = 16)
(
input clk,
input in_valid,
input [BITS-1:0] a,
output out_valid,
output [BITS-1:0] c
);

if (PRECISION == "SINGLE")
single_log2_table_one_to_two
#(.STEPS(STEPS))
single_log2_table_one_to_two1
(
.clk,
.in_valid,
.a,
.out_valid,
.c
);

endmodule
