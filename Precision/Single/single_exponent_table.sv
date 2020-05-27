`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/13/2020 01:46:52 PM
// Design Name: 
// Module Name: single_exponent_table
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

module single_exponent_table
#(STEPS = 64, LIMIT = 8.0)
(
input clk,
input in_valid,
input [31:0] a,
output logic out_valid = 0,
output logic [31:0] c
);

localparam BITS = 32;
localparam PRECISION = "SINGLE";

typedef logic [BITS-1:0] data_t;
typedef logic [BITS-1:0] exponent_t[STEPS];

localparam MINUS_LIMIT = -LIMIT;
localparam exponent_t EXPONENTS = CalcExponents();
localparam STEP_SIZE = LIMIT / (STEPS / 2.0);
localparam data_t LIMIT_LOW = CalcLimitLow(); // Had to add wrapper function to get synthesis to set valure
localparam data_t LIMIT_HIGH = CalcLimitHigh();
localparam int BASE_2_POW_OF_LIMIT = LIMIT_HIGH[30:23];

data_t limit_high; // localparams don't seem to work in ports for other modules
data_t limit_low;

assign high_limit = CalcLimitHigh();
assign low_limit = CalcLimitLow();

logic a_gt_limit_low;
logic a_lt_limit_high;

always @(posedge clk)
  if (in_valid)
    c <= TableExponent(a);
  else
    c <= 0;

always @(posedge clk)
  out_valid <= in_valid;

function data_t CalcLimitLow();
  data_t result;
  real value;                               // Can't pass local paramater into other package??
  value = MINUS_LIMIT;
  result = ConvertShortRealToBits(value);
  return result;
endfunction

function data_t CalcLimitHigh();
  data_t result;
  real value;
  value = LIMIT;
  result = ConvertShortRealToBits(value);
  return result;
endfunction
  
/*
function real exp(real x);
  real E = 2.71828182845904;
  return E ** x;
endfunction
*/
 
function exponent_t CalcExponents();
  real x;
  real exp_x;
  data_t new_exp;
  x = MINUS_LIMIT;
  exp_x = $exp(x);
  new_exp = ConvertShortRealToBits(exp_x);
  CalcExponents[0] = new_exp; 
 
  for (int i = 0; i < STEPS; i++)
    begin
      x = -LIMIT + 2*LIMIT*i/(STEPS-1);
      exp_x = $exp(x);
    CalcExponents[i] = ConvertShortRealToBits(exp_x);
    end
  x = LIMIT;
  exp_x = $exp(x);
  new_exp = ConvertShortRealToBits(exp_x);
  CalcExponents[STEPS-1] = new_exp;
endfunction
  
function data_t TableExponent(input data_t a);
  logic [$clog2(STEPS)-1:0] exp_selection;
  int step;
  int selection;
  int exp_difference;
  if (!a_lt_limit_high)
    return EXPONENTS[STEPS-1];
  if (!a_gt_limit_low)
    return EXPONENTS[0];
  if (!a[BITS-1])
    begin                               // Assume STEP is perfect multiple of 2 for now
      exp_difference = BASE_2_POW_OF_LIMIT - a[30:23];
      //temp = real_a / STEP_SIZE;
      //step = $floor(temp);
      //selection = STEPS/2 + 1 + step;
      //return EXPONENTS[selection];
      exp_selection = STEPS / 2;
      if (exp_difference < $clog2(STEPS))
        begin
          if (exp_difference == 0)
            exp_selection = STEPS-1;
          else
            exp_selection = STEPS / 2 - 1 + ({1'b1, a[22 -: $clog2(STEPS)-2]} >> (exp_difference-1));
        end
      /*
      case (exp_difference)
        5: exp_selection = 31 + 1'b1;
        4: exp_selection = 31 + {1'b1, a[22:22]};
        3: exp_selection = 31 + {1'b1, a[22:21]};
        2: exp_selection = 31 + {1'b1, a[22:20]};
        1: exp_selection = 31 + {1'b1, a[22:19]};
        0: exp_selection = 63;
        default: exp_selection  = 32;
      endcase
      */
      return EXPONENTS[exp_selection];
      /*
      if (exp_difference < 6)
        return EXPONENTS[32 + (1 << (5 - exp_difference)) - 1];
      else
        return EXPONENTS[32];
      */
    end
  else
    begin
      exp_difference = BASE_2_POW_OF_LIMIT - a[30:23];
      exp_selection = STEPS/2-1;
      if (exp_difference < $clog2(STEPS))
        begin
          if (exp_difference == 0)
            exp_selection = 0;
          else
            exp_selection = STEPS / 2 - ({1'b1, a[22 -: $clog2(STEPS)-2]} >> (exp_difference-1));
        end
      /*
      case (exp_difference)
        5: exp_selection = 32 - 1'b1;
        4: exp_selection = 32 - {1'b1, a[22:22]};
        3: exp_selection = 32 - {1'b1, a[22:21]};
        2: exp_selection = 32 - {1'b1, a[22:20]};
        1: exp_selection = 32 - {1'b1, a[22:19]};
        0: exp_selection = 0;
        default: exp_selection  = 31;
      endcase
      */
      return EXPONENTS[exp_selection];
      //temp = real_a / STEP_SIZE;
      //step = $floor(temp);
      //selection = STEPS/2 + step;
      //return EXPONENTS[selection];
      /*
      if (exp_difference < 6)
        return EXPONENTS[32 - (1 << (5 - exp_difference))];
      return EXPONENTS[31];
      */
    end
endfunction

greater_than
#(.BITS(BITS), .PRECISION(PRECISION))
greater_than_min
(
.a,
.b(LIMIT_LOW),
.a_gt_b(a_gt_limit_low)
);

less_than
#(.BITS(BITS), .PRECISION(PRECISION))
less_than_max
(
.a,
.b(LIMIT_HIGH),
.a_lt_b(a_lt_limit_high)
);

endmodule
