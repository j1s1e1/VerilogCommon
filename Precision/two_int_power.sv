`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/29/2019 07:00:52 PM
// Design Name: 
// Module Name: two_int_power
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


module two_int_power
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
half_two_int_power two_int_power1
(
.rstn(1'b1),
.clk,
.in_valid,
.a(a),
.out_valid(out_valid),
.c(c)
);

if (PRECISION == "SINGLE")
single_two_int_power two_int_power1
(
.rstn(1'b1),
.clk,
.in_valid,
.a(a),
.out_valid(out_valid),
.c(c)
);
endmodule
