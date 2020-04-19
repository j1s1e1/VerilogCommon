`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/14/2019 06:41:00 PM
// Design Name: 
// Module Name: greater
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


module greater
#(parameter BITS = 16, PRECISION = "HALF")
(
input [BITS-1:0] a,
input [BITS-1:0] b,
output c
);

if (PRECISION == "SINGLE")
single_greater single_greater1
(
.a(a),
.b(b),
.c(c)
);

endmodule