`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/02/2020 10:53:57 PM
// Design Name: 
// Module Name: base_2_zero_exponent
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


module base_2_zero_exponent
#(BITS = 16, PRECISION = "HALF")
(    
input [BITS-1:0] a,
output [BITS-1:0] c
);

if (PRECISION == "HALF")
half_base_2_zero_exponent base_2_zero_exponent1
(
.a(a),
.c(c)
);

if (PRECISION == "SINGLE")
single_base_2_zero_exponent base_2_zero_exponent1
(
.a(a),
.c(c)
);

endmodule
