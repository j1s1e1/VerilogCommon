`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/13/2020 08:27:07 PM
// Design Name: 
// Module Name: ln_sum_exp_full
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


module ln_sum_exp_full
#(BITS = 16, PRECISION = "HALF", APROX_EXP = "FALSE")
(
input clk,
input in_valid,
input [BITS-1:0] a,
input [BITS-1:0] b,
output out_valid,
output [BITS-1:0] c
);

// Difference is time for divide one in exponent one in ln
localparam MAX_DELAY = (PRECISION == "HALF") ? 2*23 + 33 : 2*49 + 33;

logic [BITS-1:0] one;
logic [BITS-1:0] a_minus_b;
logic [BITS-1:0] abs_a_minus_b;
logic [BITS-1:0] neg_abs_a_minus_b;
logic [BITS-1:0] exp_neg_abs_a_minus_b;
logic [BITS-1:0] one_plus_exp_neg_abs_a_minus_b;
logic [BITS-1:0] max;
logic [BITS-1:0] max_d;
logic [BITS-1:0] correction;

logic out_valid_a_minus_b;
logic out_valid_exp_neg_abs_a_minus_b;
logic out_valid_add_1;
logic out_valid_ln;

assign neg_abs_a_minus_b = {~abs_a_minus_b[BITS-1], abs_a_minus_b[BITS-2:0]};

max
#(.BITS(BITS), .PRECISION(PRECISION))
max_1
(
.rstn(1'b1),
.clk,
.in_valid,
.a,
.b,
.out_valid(),
.b_max(),
.c(max)
);

delay #(.DELAY(MAX_DELAY), .WIDTH(BITS))
delay_sign1
(
.rstn(1'b1),
.clk(clk),
.a(max),
.c(max_d)
); 

subtract
#(.BITS(BITS), .PRECISION(PRECISION))
subtract_b_from_a
(
.rstn(1'b1),
.clk,
.in_valid,
.a,
.b,
.out_valid(out_valid_a_minus_b),
.c(a_minus_b)
);

abs
#(.BITS(BITS), .PRECISION(PRECISION))
abs_of_a_minus_b
(
.a(a_minus_b),
.c(abs_a_minus_b)
);

exponent
#(.BITS(BITS), .PRECISION(PRECISION))
exponent_neg_abs_a_minus_b
(
.rstn(1'b1),
.clk,
.in_valid(out_valid_a_minus_b),
.a(neg_abs_a_minus_b),
.out_valid(out_valid_exp_neg_abs_a_minus_b),
.c(exp_neg_abs_a_minus_b)
);

add
#(.BITS(BITS), .PRECISION(PRECISION))
add_1
(
.rstn(1'b1),
.clk,
.in_valid(out_valid_exp_neg_abs_a_minus_b),
.a(one),
.b(exp_neg_abs_a_minus_b),
.out_valid(out_valid_add_1),
.c(one_plus_exp_neg_abs_a_minus_b)
);

ln
#(.BITS(BITS), .PRECISION(PRECISION))
ln_1
(
.clk,
.in_valid(out_valid_add_1),
.a(one_plus_exp_neg_abs_a_minus_b),
.out_valid(out_valid_ln),
.c(correction)
);

add
#(.BITS(BITS), .PRECISION(PRECISION))
add
(
.rstn(1'b1),
.clk,
.in_valid(out_valid_ln),
.a(max_d),
.b(correction),
.out_valid,
.c
);

set_value
#(.BITS(BITS), .PRECISION(PRECISION), .VALUE("PLUS_ONE"))
set_value_one
(
.value(one)
);

endmodule
