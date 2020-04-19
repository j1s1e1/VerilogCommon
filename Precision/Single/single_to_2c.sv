`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/26/2020 12:42:44 AM
// Design Name: 
// Module Name: single_to_2c
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


module single_to_2c
(
input [31:0] single,
input [7:0] max_exp,
output [39:0] two_c
);

logic [7:0] shift;
logic [39:0] shifted;

assign shift = max_exp - single[30:23];
assign shifted = (single == 0) ? 0 :
                               ({1,single[22:0]} << 14) >> shift;
assign two_c = (single[31]) ? ~shifted + 1 : shifted;

endmodule
