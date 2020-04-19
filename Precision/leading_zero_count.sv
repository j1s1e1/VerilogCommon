`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/22/2018 09:01:57 PM
// Design Name: 
// Module Name: leading_zero_count
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
//
// LUT 70
//
//////////////////////////////////////////////////////////////////////////////////


module leading_zero_count
#
(
parameter WIDTH = 64
)
(
input [WIDTH-1:0] a,
output reg [$clog2(WIDTH):0] c
);

integer i;

always @(a)
  begin
    c = WIDTH;
    for (i = 0; i < WIDTH; i = i + 1)
      if (a[i]) c = WIDTH - 1 - i;
  end

endmodule
