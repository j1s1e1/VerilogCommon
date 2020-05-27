`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/13/2020 06:49:23 PM
// Design Name: 
// Module Name: single_log2_table_one_to_two
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

import real_pkg::*;

module single_log2_table_one_to_two
#(BITS = 32, PRECISION = "SINGLE", STEPS = 16)
(
input clk,
input in_valid,
input [BITS-1:0] a,
output logic out_valid = 0,
output logic [BITS-1:0] c = 0
);

typedef logic [BITS-1:0] log2_t[STEPS];

localparam FIRST_MANTISSA_BIT = 22;
localparam log2_t LOG2 = CalcLog2();

always @(posedge clk)
  out_valid <= in_valid;
  
always @(posedge clk)
  c <= TableLog2(a);
  
function log2_t CalcLog2();
  real step;
  real result_real;
  logic [BITS-1:0] result;
  step = 1.0 / STEPS;
  for (int i = 0; i < STEPS; i++)
    begin
      result_real = $ln(1.0 + i * step)/$ln(2);
      result = ConvertShortRealToBits(result_real);
      CalcLog2[i] = result;
    end
endfunction
  
function [BITS-1:0] TableLog2([BITS-1:0] x);
  // Values should all be between 1.0 and 2.0 not including 2.0
  // Selection can be made based on mantissa bits
  return LOG2[a[FIRST_MANTISSA_BIT -: $clog2(STEPS)]];
  /*
  real x_real;
  real ln_x;
  real ln_2;
  real result_real;
  x_real = $bitstoshortreal(x);
  ln_x = $ln(x_real);
  ln_2 = $ln(2);
  result_real = ln_x / ln_2;
  return $shortrealtobits(result_real);
  */
endfunction
  
endmodule
