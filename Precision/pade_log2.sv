`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/02/2020 09:17:08 PM
// Design Name: 
// Module Name: pade_log2
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
// Approximation for Log2(1.x) for fractional x between 0 and 1
// Based on Pade approximation for ln x 1/ln(2)
// ln(1+x) = x(6+x)/(6+4x)
// log2(1+x) = 1/(ln(2))*ln(1+x) = log2(e)*ln(1+x)
//
//////////////////////////////////////////////////////////////////////////////////


module pade_log2
#(BITS = 16, PRECISION = "HALF")
(
input clk,
input in_valid,
input [BITS-1:0] a,
output out_valid,
output [BITS-1:0] c
);

logic [BITS-1:0] x;
logic [BITS-1:0] one;
logic [BITS-1:0] four;
logic [BITS-1:0] six;
logic [BITS-1:0] four_x;
logic [BITS-1:0] four_x_plus_six;
logic [BITS-1:0] sqr_x;
logic [BITS-1:0] six_x;
logic [BITS-1:0] sqr_x_plus_six_x;
logic [BITS-1:0] ln_one_plus_x;
logic [BITS-1:0] log2_e;

logic out_valid_one_from_a;
logic out_valid_sqr_x;
logic out_valid_four_x;
logic out_valid_six_x;
logic out_valid_four_x_plus_six;
logic out_valid_sqr_x_plus_six_x;
logic out_valid_ln_one_plus_x;

subtract
#(.BITS(BITS), .PRECISION(PRECISION))
subtract_one_from_a
(
.rstn(1'b1),
.clk,
.in_valid,
.a(a),
.b(one),
.out_valid(out_valid_one_from_a),
.c(x)
);

multiply
#(.BITS(BITS), .PRECISION(PRECISION))
multiply_sqr_x
(
.rstn(1'b1),
.clk,
.in_valid(out_valid_one_from_a),
.a(x),
.b(x),
.out_valid(out_valid_sqr_x),
.c(sqr_x)
);

multiply
#(.BITS(BITS), .PRECISION(PRECISION))
multiply_four_x
(
.rstn(1'b1),
.clk,
.in_valid(out_valid_one_from_a),
.a(four),
.b(x),
.out_valid(out_valid_four_x),
.c(four_x)
);

multiply
#(.BITS(BITS), .PRECISION(PRECISION))
multiply_six_x
(
.rstn(1'b1),
.clk,
.in_valid(out_valid_one_from_a),
.a(six),
.b(x),
.out_valid(out_valid_six_x),
.c(six_x)
);

add
#(.BITS(BITS), .PRECISION(PRECISION))
add_four_x_plus_six
(
.rstn(1'b1),
.clk,
.in_valid(out_valid_four_x),
.a(four_x),
.b(six),
.out_valid(out_valid_four_x_plus_six),
.c(four_x_plus_six)
);

add
#(.BITS(BITS), .PRECISION(PRECISION))
add_sqr_x_plus_six_x
(
.rstn(1'b1),
.clk,
.in_valid(out_valid_sqr_x),
.a(sqr_x),
.b(six_x),
.out_valid(out_valid_sqr_x_plus_six_x),
.c(sqr_x_plus_six_x)
);

divide
#(.BITS(BITS), .PRECISION(PRECISION))
divide_ln_one_plus_x
(
.rstn(1'b1),
.clk,
.in_valid(out_valid_sqr_x_plus_six_x),
.a(sqr_x_plus_six_x),
.b(four_x_plus_six),
.out_valid(out_valid_ln_one_plus_x),
.c(ln_one_plus_x)
);

multiply
#(.BITS(BITS), .PRECISION(PRECISION))
multiply_log2_e_ln_one_plus_x
(
.rstn(1'b1),
.clk,
.in_valid(out_valid_ln_one_plus_x),
.a(log2_e),
.b(ln_one_plus_x),
.out_valid,
.c(c)
);


set_value
#(.BITS(BITS), .PRECISION(PRECISION), .VALUE("LOG2_E"))
set_value_log2_e
(
.value(log2_e)
);

set_value
#(.BITS(BITS), .PRECISION(PRECISION), .VALUE("PLUS_ONE"))
set_value_one
(
.value(one)
);


set_value
#(.BITS(BITS), .PRECISION(PRECISION), .VALUE("FOUR"))
set_value_four
(
.value(four)
);

set_value
#(.BITS(BITS), .PRECISION(PRECISION), .VALUE("SIX"))
set_value_six
(
.value(six)
);

endmodule
