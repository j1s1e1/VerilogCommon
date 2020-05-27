`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/14/2019 06:41:00 PM
// Design Name: 
// Module Name: less_than
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


module less_than
#(parameter BITS = 16, PRECISION = "HALF")
(
input [BITS-1:0] a,
input [BITS-1:0] b,
output a_lt_b
);

if (PRECISION == "SINGLE")
single_less_than single_less_than1
(
.a(a),
.b(b),
.a_lt_b(a_lt_b)
);

endmodule