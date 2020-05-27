`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/29/2019 04:47:30 PM
// Design Name: 
// Module Name: exponent
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


module exponent
#(parameter BITS = 32, PRECISION = "FIXED_16_16")
(
input rstn,
input clk,
input in_valid,
input [BITS-1:0] a,
output out_valid,
output [BITS-1:0] c
);

logic out_valid_m1;
logic [BITS-1:0] log2e;
logic [BITS-1:0] a_x_log2e;

logic [BITS-1:0] ln_of_min;
logic [BITS-1:0] ln_of_max;

logic [BITS-1:0] clip_a;

clip
#(.BITS(BITS), .PRECISION(PRECISION))
clip1
(
.a,
.min(ln_of_min),
.max(ln_of_max),
.c(clip_a)
);

set_value #(.BITS(BITS), .PRECISION(PRECISION), .VALUE("LOG2_E"))
set_value_log2e (.value(log2e));

multiply
#(.BITS(BITS), .PRECISION(PRECISION))
multiply1
(
.rstn(rstn),
.clk(clk),
.in_valid(in_valid),
.a(clip_a),
.b(log2e),
.out_valid(out_valid_m1),
.c(a_x_log2e)
); 

fm_exp2
#(.BITS(BITS), .PRECISION(PRECISION))
fm_exp2_1
(
.rstn(rstn),
.clk(clk),
.in_valid(out_valid_m1),
.a(a_x_log2e),
.out_valid(out_valid),
.c(c)
);

set_value
#(.BITS(BITS), .PRECISION(PRECISION), .VALUE("LN_OF_MIN"))
set_value_min_value
(
.value(ln_of_min)
);     

set_value
#(.BITS(BITS), .PRECISION(PRECISION), .VALUE("LN_OF_MAX"))
set_value_max_value
(
.value(ln_of_max)
);

endmodule
