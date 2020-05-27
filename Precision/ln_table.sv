`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/13/2020 04:14:23 PM
// Design Name: 
// Module Name: ln_table
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


module ln_table
#(BITS = 16, PRECISION = "HALF", STEPS = 16)
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

log2_table
#(.BITS(BITS), .PRECISION(PRECISION), .STEPS(STEPS))
log2_table1
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
