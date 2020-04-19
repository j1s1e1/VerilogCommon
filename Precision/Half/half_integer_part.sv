`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2018 10:09:08 AM
// Design Name: 
// Module Name: half_integer_part
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


module half_integer_part(
input rstn,
input clk,
input in_valid,
input [15:0] a,
output reg out_valid,
output reg [15:0] c
);

int half_bit_offset;

assign half_bit_offset = (a[14:10] > 13) ? 
                            10 - (a[14:10] - 14) :
                            10;  

always @(posedge clk)
  if (!rstn)
    out_valid <= 0;
  else
    out_valid <= in_valid;

always @(posedge clk)
  if (!rstn)
    c <= 0;
  else
    c <= (a[14:10] > 14) ?
            {a[15:10], ((a[9:0] >> (half_bit_offset + 1)) << (half_bit_offset + 1))} :
            0;

endmodule
