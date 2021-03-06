`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2018 03:03:05 PM
// Design Name: 
// Module Name: max
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


module max
#(parameter BITS = 16, PRECISION = "HALF")
(
input rstn,
input clk,
input in_valid,
input [BITS-1:0] a,
input [BITS-1:0] b,
output out_valid,
output b_max,
output reg [BITS-1:0] c
);

if (PRECISION == "HALF")
half_max half_max1
(
.rstn(1'b1),
.clk,
.in_valid,
.a(a),
.b(b),
.out_valid(out_valid),
.b_max(b_max),
.c(c)
);

if (PRECISION == "SINGLE")
single_max single_max1
(
.rstn(1'b1),
.clk,
.in_valid,
.a(a),
.b(b),
.out_valid(out_valid),
.b_max(b_max),
.c(c)
);
                  
endmodule