`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/11/2020 09:56:27 PM
// Design Name: 
// Module Name: exponent_table
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

module exponent_table
#(parameter BITS = 32, PRECISION = "SINGLE", STEPS = 64, LIMIT = 8.0)
(
input clk,
input in_valid,
input [BITS-1:0] a,
output logic out_valid,
output logic [BITS-1:0] c
);

if (PRECISION == "SINGLE")
single_exponent_table
#(.STEPS(STEPS), .LIMIT(LIMIT))
single_exponent_table1
(
.clk,
.in_valid,
.a,
.out_valid,
.c
);

endmodule
