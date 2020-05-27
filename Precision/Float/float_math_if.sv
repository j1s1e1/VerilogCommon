`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/20/2020 07:39:50 AM
// Design Name: 
// Module Name: float_math_if
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
//  This file provides functions to operate on float types in a single cycle.
//  This can be used to test functions before converting to modules with timed
//  functions.
//
//
//////////////////////////////////////////////////////////////////////////////////


interface float_math_if #(BITS = 32, EXP_WIDTH = 8);

typedef logic [BITS-1:0] float_t;
typedef logic [EXP_WIDTH-1:0] exponent_t;
typedef logic [MANTISSA_BITS-2:0] mantissa_t; // does not include assumed one bit
typedef logic [$clog2(MANTISSA_BITS):0] shift_t;

localparam EXP_START = BITS-2;
localparam MANTISSA_BITS = BITS - EXP_WIDTH;  // Includes assumed one bit
localparam SUM_WIDTH = 2 * MANTISSA_BITS + 1;
localparam SUM_SHIFT = SUM_WIDTH - MANTISSA_BITS - 1;

exponent_t a_exp;
exponent_t b_exp;
exponent_t c_exp = 0;
mantissa_t a_mantissa;  // does not include assumed one bit
mantissa_t b_mantissa;
mantissa_t c_mantissa;
logic a_sign;
logic b_sign;
logic c_sign;

logic a_zero;
logic b_zero;
logic expa_gt_expb;
logic expb_gt_expa;
logic mana_gt_manb;
logic manb_gt_mana;
logic abs_a_gt_abs_b;
logic abs_b_gt_abs_a;
shift_t ashift;
shift_t bshift;
logic minus;
shift_t leading_zeros;
float_t c;

function void SetABParts(float_t a, float_t b);
  a_zero = (a == 0); 
  b_zero = (b == 0);     
  a_sign = a[BITS-1];
  b_sign = b[BITS-1];
  a_exp = a[EXP_START -: EXP_WIDTH];
  b_exp = b[EXP_START -: EXP_WIDTH];
  a_mantissa = a[MANTISSA_BITS-2:0];
  b_mantissa = b[MANTISSA_BITS-2:0];
endfunction

function int CountLeadingZeros(logic [63:0] value, int size);
  int result;
  result = 0;
  for (int i = size-1; i >= 0; i--)
    if (value[i] == 0)
      result++;
    else
      break;
   return result;
endfunction

function void CompareAB(float_t a, float_t b);
  expa_gt_expb = (a_exp > b_exp) ? 1 : 0;
  expb_gt_expa = (b_exp > a_exp) ? 1 : 0;
  mana_gt_manb = (a_mantissa> b_mantissa) ? 1 : 0;
  manb_gt_mana = (b_mantissa > a_mantissa) ? 1 : 0;
  abs_a_gt_abs_b = (expa_gt_expb | (!expb_gt_expa & mana_gt_manb));
  abs_b_gt_abs_a = (expb_gt_expa | (!expa_gt_expb & manb_gt_mana));
endfunction

function float_t Subtract(float_t a, float_t b);
  return Add(a, {~b[BITS-1],b[BITS-2:0]});
endfunction

function float_t Add(float_t a, float_t b);
  logic [SUM_WIDTH-1:0] sum;
  sum = 0;
  SetABParts(a, b);
  CompareAB(a, b);
  ashift = expb_gt_expa ? 
                    (b_exp - a_exp < MANTISSA_BITS) ? b_exp - a_exp : MANTISSA_BITS
                    : 0;
  bshift = expa_gt_expb ? 
                    (a_exp - b_exp < MANTISSA_BITS) ? a_exp - b_exp : MANTISSA_BITS                     
                    : 0;                    
  minus = a_sign != b_sign;  

  c_sign = (a_sign == b_sign) ? a_sign :
             expa_gt_expb ? a_sign :
             expb_gt_expa ? b_sign :
             mana_gt_manb ? a_sign : 
             manb_gt_mana ? b_sign : 1'b0;
             
  sum = (minus) ?
                (abs_a_gt_abs_b) ?
                    ({1'b1,a_mantissa} << (SUM_SHIFT - ashift)) - ({1'b1,b_mantissa} << (SUM_SHIFT - bshift)) :
                    ({1'b1,b_mantissa} << (SUM_SHIFT - bshift)) - ({1'b1,a_mantissa} << (SUM_SHIFT - ashift)) :
                (a_zero) ?
                    (b_zero) ?
                         0 :
                    ({1'b1,b_mantissa} << (SUM_SHIFT - bshift)) :
                (b_zero) ?
                    ({1'b1,a_mantissa} << (SUM_SHIFT - ashift)) :
                    ({1'b1,a_mantissa} << (SUM_SHIFT - ashift)) + ({1'b1,b_mantissa} << (SUM_SHIFT - bshift));            
             
  leading_zeros = CountLeadingZeros(sum, SUM_WIDTH);
      
  c_exp = (leading_zeros < SUM_WIDTH) ?
                    expb_gt_expa ?
                    b_exp + (8'b1 - leading_zeros):
                    a_exp + (8'b1 - leading_zeros):
                    0;
                

  c_mantissa = (leading_zeros < SUM_WIDTH) ?
                       (leading_zeros < SUM_SHIFT + 1) ?
                            sum >> (SUM_SHIFT + 1 - leading_zeros):
                            sum << (leading_zeros - SUM_SHIFT + 1): 
                       0;
                       
  c = {c_sign,c_exp,c_mantissa};
  return c;
endfunction

function logic GreaterThan(float_t a, float_t b);
  if ($signed(a) > $signed(b))
    return 1;
  else
    return 0;
   SetABParts(a, b);
   if (a_sign != b_sign)
     if (a_sign)
       return 0;
     else
       return 1;
   CompareAB(a, b);
   if (abs_a_gt_abs_b)
     if (a_sign)
       return 0;
     else 
       return 1;
   if (abs_b_gt_abs_a)
      if (a_sign)
       return 1;
     else 
       return 0;  
   return 0;
endfunction

endinterface
