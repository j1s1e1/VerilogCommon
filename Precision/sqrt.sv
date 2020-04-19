`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/14/2019 06:41:00 PM
// Design Name: 
// Module Name: sqrt
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


module sqrt
#(parameter BITS = 16, PRECISION = "HALF")
(
input rstn,
input clk,
input in_valid,
input [BITS-1:0] a,
output out_valid,
output [BITS-1:0] c
);

if (PRECISION == "SINGLE")
single_sqrt single_sqrt1
(
.rstn(1'b1),
.clk,
.in_valid,
.a(a),
.out_valid(out_valid),
.c(c)
);

endmodule