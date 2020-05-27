`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/02/2020 10:57:02 PM
// Design Name: 
// Module Name: single_base_2_zero_exponent
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


module single_base_2_zero_exponent
(
input [31:0] a,
output [31:0] c
);

logic [7:0] zero_exponent;

assign zero_exponent = 127;
assign c = {a[31],zero_exponent,a[22:0]};
endmodule
