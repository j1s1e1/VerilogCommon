`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/14/2019 06:41:00 PM
// Design Name: 
// Module Name: add
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


module add
#(parameter BITS = 16, PRECISION = "HALF")
(
input rstn,
input clk,
input in_valid,
input [BITS-1:0] a,
input [BITS-1:0] b,
output out_valid,
output [BITS-1:0] c
);

if (PRECISION == "HALF")
half_add half_add1
(
.rstn(1'b1),
.clk,
.in_valid,
.a(a),
.b(b),
.out_valid(out_valid),
.c(c)
);

if (PRECISION == "SINGLE")
single_add single_add1
(
.rstn(1'b1),
.clk,
.in_valid,
.a(a),
.b(b),
.out_valid(out_valid),
.c(c)
);

endmodule
