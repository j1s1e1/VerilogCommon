`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/20/2018 08:52:03 PM
// Design Name: 
// Module Name: integer_sqrt
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
//  242 LUT 664 FF 15 DSP
//
//////////////////////////////////////////////////////////////////////////////////


module integer_sqrt
#
(
parameter WIDTH=32
)
(
input rstn,
input clk,
input [WIDTH-1:0] a,
output reg [WIDTH/2-1:0] c
);
reg [WIDTH-1:0] a_in[WIDTH/2+1];
reg [WIDTH/2-1:0] sqrt_partial[WIDTH/2+1];

integer i;

always @(posedge clk)
  if (!rstn)
    for (i = 0; i < WIDTH/2 + 1; i= i + 1)
      begin
        a_in[i] <= 0;
        sqrt_partial[i] <= 0;
      end
  else
    begin
      a_in[0] <= a;
      sqrt_partial[0] = 0;
      for (int i = 1; i < WIDTH/2 + 1; i = i + 1)
        begin
          a_in[i] <= a_in[i-1];
          if (a_in[i-1] >= ({{WIDTH/2{1'b0}},sqrt_partial[i-1]} | (1 << (WIDTH/2-i))) *
                           ({{WIDTH/2{1'b0}},sqrt_partial[i-1]} | (1 << (WIDTH/2-i))))
            sqrt_partial[i] <= sqrt_partial[i-1] | (1 << (WIDTH/2 - i));
          else
            sqrt_partial[i] <= sqrt_partial[i-1];
        end
    end

always @(posedge clk)
  if (!rstn)
    c <= 0;
  else
    c <= sqrt_partial[WIDTH/2];
endmodule
