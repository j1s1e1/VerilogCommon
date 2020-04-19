`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/29/2018 10:10:03 PM
// Design Name: 
// Module Name: delay_signed_v
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


module delay_signed_v
#(parameter DELAY = 1, WIDTH = 1, LENGTH = 1)
(
input rstn,
input clk,
input signed [WIDTH-1:0] a[LENGTH],
output signed [WIDTH-1:0] c[LENGTH]
);

generate
  genvar g;
  for (g = 0; g < LENGTH; g = g + 1)
    begin
      delay_signed #(.DELAY(DELAY), .WIDTH(WIDTH))
      delay_signed_array
      (
        .rstn(rstn),
        .clk(clk),
        .a(a[g]),
        .c(c[g])
      ); 
    end
endgenerate

endmodule
