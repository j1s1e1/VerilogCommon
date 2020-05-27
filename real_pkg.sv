`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/08/2020 11:21:06 PM
// Design Name: 
// Module Name: real_pkg
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


package real_pkg;

function logic [31:0] ConvertShortRealToBits(real valueIn);
  logic [31:0] result;
  real value;
  real ln_value;
  real ln_2;
  real log2_value;
  int log2_int_value;
  real divisor;
  real mantissa_value;
  int mantissa_int;
  real multiplier;
  value = valueIn;
  if (value == 0)
    return 0;
  result[31] = (value < 0) ? 1 : 0;
  if (value < 0) value = -value;
  //return 7;
  ln_value = $ln(value);
  ln_2 = $ln(2);
  //return 8;
  log2_value = ln_value/ln_2;
  log2_int_value = $floor(log2_value);
  //return 9;
  divisor = $pow(2,log2_int_value);
  mantissa_value = value / divisor;
  //return 10;
  result[30:23] = 127 + log2_int_value;
  multiplier =  $pow(2,23);
  mantissa_value = mantissa_value - 1.0;
  mantissa_value = mantissa_value * multiplier;
  mantissa_int = $floor(mantissa_value);            // This extra step was necessary for sim
  result[22:0] = mantissa_int;
  return result;
endfunction

function [31:0] SingleFromHalf;
  input [15:0] half;
  logic sign;
  logic [7:0] exponent;
  logic [22:0] mantissa;
  begin
    sign = half[15];
    exponent = 8'd127 + {3'b0,half[14:10]} - 8'd15;
    mantissa = {half[9:0],13'b0};
    SingleFromHalf = (half[14:0] == 0) ?  
                        32'b0 :
                        {sign,exponent,mantissa};
  end                    
endfunction

function [15:0] RealToHalf;
  input real  a_real;
  logic [31:0] a_single;
  logic [4:0] a_exp;
  begin
    a_single = ConvertShortRealToBits(a_real);
    if (a_single[30:23] < (127 - 15))
      RealToHalf = 16'b0;
    else
      begin
        if (a_single[30:23] > (127 + 16))
          RealToHalf = {a_single[31],15'b111_1111_1111_1111};
        else
          begin
            a_exp = a_single[30:23] - 127 + 15;
            RealToHalf = (a_single==0) ? 0 : {a_single[31],a_exp,a_single[22:13]};
          end
      end
  end
endfunction

function real ConvertShortBitsToReal(input logic [31:0] bits);
  int exponent_int;
  real exponent;
  real mantissa;
  real divisor;
  real sign;
  real result;
  if (bits[30:23] == 0)
    return 0;
  sign = (bits[31]) ? -1.0 : 1.0;
  exponent_int = bits[30:23] - 127;
  exponent_int = $pow(2, exponent_int);
  exponent = exponent_int;
  mantissa = {1'b1,bits[22:0]};
  divisor = $pow(2, 23);
  mantissa = mantissa / divisor;
  result = exponent * mantissa;
  result = sign * result;
  return result;
endfunction

class real_array #(N=4);
typedef struct 
{
real value;
}element_t;

element_t element[N];

typedef element_t elements[N];

function real Get(int index);
  return element[index].value;
endfunction

function void Set(int index, real value);
  element[index].value = value;
endfunction

endclass

endpackage
