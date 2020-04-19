`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2019 02:39:28 PM
// Design Name: 
// Module Name: fixed_integer_part
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


module fixed_integer_part
#(parameter BITS = 8, PRECISION = "FIXED_04_04")
(
input clk,
input in_valid,
input signed [BITS-1:0] a,
output out_valid,
output signed [BITS-1:0] c
);

parameter FRACTION = 10 * (PRECISION[15:8] - 8'h30) + PRECISION[7:0] - 8'h30;

assign out_valid = in_valid;
assign c = {a[BITS-1:FRACTION],{FRACTION{1'b0}}};

endmodule
