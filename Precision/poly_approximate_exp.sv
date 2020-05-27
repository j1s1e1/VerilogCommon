`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/08/2020 12:43:44 AM
// Design Name: 
// Module Name: poly_approximate_exp
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
//
//  Replacement for pade approximation to avoid division
//  Approximates 2^fpart for fpart between -0.5 and +0.5
//
//////////////////////////////////////////////////////////////////////////////////

import real_pkg::*;

module poly_approximate_exp
#(parameter BITS = 16, PRECISION = "HALF", DEGREE = 3)
(
input rstn,
input clk,
input in_valid,
input [BITS-1:0] fpart,
output logic out_valid,
output logic [BITS-1:0] x
);

logic [BITS-1:0] offset;        // Parameters don't work because system tasks fail in simulation
logic [BITS-1:0] x_factor;
logic [BITS-1:0] x_sqr_factor;

logic [BITS-1:0] fpart_d = 0;
logic [BITS-1:0] x_sqr;
logic [BITS-1:0] x_times_x_factor;
logic [BITS-1:0] x_sqr_times_x_sqr_factor;
logic [BITS-1:0] x_times_x_factor_plus_offset;

//always @(posedge clk)
//  x <= $shortrealtobits($pow(2, $bitstoshortreal(fpart)));

logic out_valid_multiply_x_x;
logic out_valid_multiply_x_x_factor;
logic out_valid_multiply_x_sqr_x_sqr_factor;
logic out_valid_add1;

assign offset = ConvertShortRealToBits(1.0);
assign x_factor = ConvertShortRealToBits(0.703076774670079);
assign x_sqr_factor = ConvertShortRealToBits(0.242640316019254);

always @(posedge clk)
  fpart_d <= fpart;
multiply 
#(.BITS(BITS), .PRECISION(PRECISION))
multiply_x_x
(
.rstn(rstn),
.clk(clk),
.in_valid,
.a(fpart),
.b(fpart),
.out_valid(out_valid_multiply_x_x),
.c(x_sqr)
);

multiply 
#(.BITS(BITS), .PRECISION(PRECISION))
multiply_x_x_factor
(
.rstn(rstn),
.clk(clk),
.in_valid,
.a(fpart_d),
.b(x_factor),
.out_valid(out_valid_multiply_x_x_factor),
.c(x_times_x_factor)
);

multiply 
#(.BITS(BITS), .PRECISION(PRECISION))
multiply_x_sqr_x_sqr_factor
(
.rstn(rstn),
.clk(clk),
.in_valid(out_valid_multiply_x_x),
.a(x_sqr),
.b(x_sqr_factor),
.out_valid(out_valid_multiply_x_sqr_x_sqr_factor),
.c(x_sqr_times_x_sqr_factor)
);

add 
#(.BITS(BITS), .PRECISION(PRECISION))
add1
(
.rstn(rstn),
.clk(clk),
.in_valid(out_valid_multiply_x_x_factor),
.a(x_times_x_factor),
.b(offset),
.out_valid(out_valid_add1),
.c(x_times_x_factor_plus_offset)
);

add 
#(.BITS(BITS), .PRECISION(PRECISION))
add2
(
.rstn(rstn),
.clk(clk),
.in_valid(out_valid_add1),
.a(x_sqr_times_x_sqr_factor),
.b(x_times_x_factor_plus_offset),
.out_valid,
.c(x)
);

endmodule
