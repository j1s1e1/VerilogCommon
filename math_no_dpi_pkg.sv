`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/25/2020 08:38:35 AM
// Design Name: 
// Module Name: math_no_dpi_pkg
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


package math_no_dpi_pkg;

real PI = 3.14159;

function real sin(real x);      // Bhaskara I's sine approximation formula
  real x_0_180;
  int sign;
  x_0_180 = mod(x, 2 * PI);
  if (x_0_180 < 0)
    x_0_180 = x_0_180 + 2 * PI;
  sign = 1;
  if (x_0_180 > PI)
    begin
      sign = -1;
      x_0_180 = x_0_180 - PI;
    end
  
  return sign * (16 * x_0_180 * (PI - x_0_180)) / (5 * PI**2 - (4 * x_0_180) * (PI - x_0_180));
endfunction

function real cos(real x);      // Bhaskara I's sine approximation formula
  return sin(x + PI/2);
endfunction

function real fmaf(real x, real y, real z);
  return x * y + z;
endfunction

function real log(real a);
  real m, r, s, t, i, f;
  int e;
  int a_cast_int;
  int m_cast_int;
  a_cast_int = $shortrealtobits(a);
  e = (a_cast_int - 32'h3f2aaaab) & 32'hff800000;
  m_cast_int = a_cast_int - e;
  m = $bitstoshortreal(m_cast_int);
  i = e * 1.19209290e-7; // 0x1.0p-23
  /* m in [2/3, 4/3] */
  f = m - 1.0;
  s = f * f;
  /* Compute log1p(f) for f in [-1/3, 1/3] */
  r = fmaf (0.230836749, f, -0.279208571); // 0x1.d8c0f0p-3, -0x1.1de8dap-2
  t = fmaf (0.331826031, f, -0.498910338); // 0x1.53ca34p-2, -0x1.fee25ap-2
  r = fmaf (r, s, t);
  r = fmaf (r, s, f);
  r = fmaf (i, 0.693147182, r); // 0x1.62e430p-1 // log(2) 
  return r;
endfunction

function real log10(real x);
  return log(x)/log(10);
endfunction

real E = 2.71828182845904;

function real exp(real x);
  return E**x;
endfunction

function real exp3(real x);  // Pade approximation
   return (1.0 + 1.0/2.0 * x + 1.0/8.0 * x**2 + 1.0/72.0 * x**3 + 1.0/1008.0 * x**4 + 1.0/30240.0 * x**5)/
          (1.0 - 1.0/2.0 * x + 1.0/8.0 * x**2 - 1.0/72.0 * x**3 + 1.0/1008.0 * x**4 - 1.0/30240.0 * x**5);
endfunction

function real exp2(real x);
  int temp;
  temp = x * 32'hB5645F + 32'h3F7893F5;
   return $bitstoshortreal(temp);
endfunction

function real sqrt(real x);
  return exp(0.5*log(x));
endfunction

function real sqrt2(real x);
  return exp(0.5*log(x));
endfunction

function real mod(real x, real y);
  real ratio;
  int ratio_int;
  ratio = x / y;
  ratio_int = $rtoi(ratio);
  mod = x - ratio_int * y;
endfunction

function real sinc(real angle);
  if (angle == 0)
    sinc = 1;
  else
    sinc = sin(angle)/angle;
endfunction

function real pow(real base, real exponent);
  return base**exponent;
endfunction

function real fmod(real x, real y);
  return mod(x, y);
endfunction

endpackage
