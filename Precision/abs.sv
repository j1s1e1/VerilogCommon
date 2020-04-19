`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/14/2019 06:41:00 PM
// Design Name: 
// Module Name: abs
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


module abs
#(parameter BITS = 16, PRECISION = "HALF")
(
input [BITS-1:0] a,
output logic [BITS-1:0] c
);

if (PRECISION == "HALF")
  assign c = {1'b0,a[14:0]};

if (PRECISION == "SINGLE")
  assign c = {1'b0,a[30:0]};

endmodule
