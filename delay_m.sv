`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/18/2020 02:09:29 PM
// Design Name: 
// Module Name: delay_m
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


module delay_m
#(parameter DELAY = 1, WIDTH = 1, R = 1, C = 1)
(
input clk,
input [WIDTH-1:0] a[R][C],
output [WIDTH-1:0] c[R][C]
);

generate
  genvar g;
  for (g = 0; g < R; g = g + 1)
    begin
      delay_v #(.DELAY(DELAY), .WIDTH(WIDTH), .LENGTH(C))
      delay_v_array
      (
        .rstn(1'b1),
        .clk(clk),
        .a(a[g]),
        .c(c[g])
      ); 
    end
endgenerate

endmodule
