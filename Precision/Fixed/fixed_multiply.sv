`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2019 02:34:45 PM
// Design Name: 
// Module Name: fixed_multiply
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


module fixed_multiply
#(parameter BITS = 8, PRECISION = "FIXED_04_04")
(
input clk,
input in_valid,
input signed [BITS-1:0] a,
input signed [BITS-1:0] b,
output reg out_valid,
output reg signed [BITS-1:0] c
);

parameter FRACTION = 10 * (PRECISION[15:8] - 8'h30) + PRECISION[7:0] - 8'h30;

logic signed [BITS*2-1:0] product;

assign product = a * b;

always @(posedge clk)
  out_valid <= in_valid;

always @(posedge clk)
  c <= {product[BITS*2-1],product[BITS+FRACTION-2:FRACTION]};

endmodule
