`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2019 03:34:21 PM
// Design Name: 
// Module Name: subtract
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


module subtract
#(parameter BITS = 16, PRECISION = "HALF")
(
input rstn,
input clk,
input in_valid,
input [BITS-1:0] a,
input [BITS-1:0] b,
output out_valid,
output [BITS-1:0] c
);

if (PRECISION == "HALF")
half_add half_subtract1
(
.rstn(1'b1),
.clk,
.in_valid,
.a(a),
.b({~b[BITS-1],b[BITS-2:0]}),
.out_valid(out_valid),
.c(c)
);

if (PRECISION == "SINGLE")
single_add single_subtract1
(
.rstn(1'b1),
.clk,
.in_valid,
.a(a),
.b({~b[BITS-1],b[BITS-2:0]}),
.out_valid(out_valid),
.c(c)
);

if(PRECISION[23:16] == "_")  // Fixed format is FIXED_XX_XX
fixed_subtract
#(.BITS(BITS), .PRECISION(PRECISION))
fixed_subtract1
(
.clk,
.in_valid,
.a,
.b,
.out_valid,
.c
);

endmodule
