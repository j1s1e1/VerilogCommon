`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/02/2020 04:26:51 PM
// Design Name: 
// Module Name: ln
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


module ln
#(BITS = 16, PRECISION = "HALF")
(
input clk,
input in_valid,
input [BITS-1:0] a,
output out_valid,
output [BITS-1:0] c
);

logic [BITS-1:0] log2_a;
logic [BITS-1:0] ln_2;
logic out_valid_log2_a;

log2
#(.BITS(BITS), .PRECISION(PRECISION))
log2_1
(
.clk,
.in_valid,
.a,
.out_valid(out_valid_log2_a),
.c(log2_a)
);

multiply
#(.BITS(BITS), .PRECISION(PRECISION))
multiply_
(
.rstn(1'b1),
.clk,
.in_valid(out_valid_log2_a),
.a(log2_a),
.b(ln_2),
.out_valid,
.c
);

set_value
#(.BITS(BITS), .PRECISION(PRECISION), .VALUE("LN_2"))
set_value_log2_e
(
.value(ln_2)
);
endmodule
