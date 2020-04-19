`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2019 02:35:06 PM
// Design Name: 
// Module Name: fixed_add
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


module fixed_add
#(parameter BITS = 8, PRECISION = "FIXED_4_4")
(
input clk,
input in_valid,
input signed [BITS-1:0] a,
input signed [BITS-1:0] b,
output reg out_valid,
output reg signed [BITS-1:0] c
);

always @(posedge clk)
  out_valid <= in_valid;

always @(posedge clk)
  c <= a + b;

endmodule
