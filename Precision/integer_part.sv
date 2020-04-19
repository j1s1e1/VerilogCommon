`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/29/2019 06:57:05 PM
// Design Name: 
// Module Name: integer_part
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


module integer_part
#(parameter BITS = 16, PRECISION = "HALF")
(
input rstn,
input clk,
input in_valid,
input [BITS-1:0] a,
output out_valid,
output [BITS-1:0] c
);

if (PRECISION == "HALF")
half_integer_part integer_part1
(
.rstn(1'b1),
.clk,
.in_valid,
.a(a),
.out_valid(out_valid),
.c(c)
);

if (PRECISION == "SINGLE")
single_integer_part single_integer_part1
(
.rstn(1'b1),
.clk,
.in_valid,
.a(a),
.out_valid(out_valid),
.c(c)
);

endmodule
