`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2019 02:45:10 PM
// Design Name: 
// Module Name: fixed_two_int_power
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


module fixed_two_int_power
#(parameter BITS = 8, PRECISION = "FIXED_4_4")
(
input clk,                    
input in_valid,               
input signed [BITS-1:0] a,    
output reg out_valid,         
output reg signed [BITS-1:0] c
);

parameter FRACTION = 10 * (PRECISION[15:8] - 8'h30) + PRECISION[7:0] - 8'h30;

always @(posedge clk)
  out_valid <= in_valid;
  
always @(posedge clk)
  c <= {1 << a[BITS-1:FRACTION],{FRACTION{1'b0}}};
  
endmodule
