`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2018 02:17:10 AM
// Design Name: 
// Module Name: single_integer_part
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


module single_integer_part(
input rstn,
input clk,
input in_valid,
input [31:0] a,
output reg out_valid = 0,
output reg [31:0] c = 0
);

int half_bit_offset;

assign half_bit_offset = (a[30:23] > 125) ? 
                            23 - (a[30:23] - 126) :
                            23;  

always @(posedge clk)
  if (!rstn)
    out_valid <= 0;
  else
    out_valid <= in_valid;

always @(posedge clk)
  if (!rstn)
    c <= 0;
  else
    c <= (a[30:23] > 126) ?
            {a[31:23], ((a[22:0] >> (half_bit_offset + 1)) << (half_bit_offset + 1))} :
            0;

endmodule
