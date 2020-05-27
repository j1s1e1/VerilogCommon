`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/02/2020 05:16:26 PM
// Design Name: 
// Module Name: base2_exp
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


module base2_exp
#(BITS = 16, PRECISION = "HALF")
(
input clk,
input in_valid,
input [31:0] a,
output logic out_valid,
output logic [31:0] c
);

if (PRECISION == "HALF")
half_base2_exp base2_exp1
(
.clk,
.in_valid,
.a(a),
.out_valid(out_valid),
.c(c)
);

if (PRECISION == "SINGLE")
single_base2_exp base2_exp1
(
.clk,
.in_valid,
.a(a),
.out_valid(out_valid),
.c(c)
);

endmodule

