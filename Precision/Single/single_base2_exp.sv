`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/02/2020 05:00:16 PM
// Design Name: 
// Module Name: single_base2_exp
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


module single_base2_exp
(
input clk,
input in_valid,
input [31:0] a,
output logic out_valid = 0,
output logic [31:0] c = 0
);

logic [7:0] exponent;
logic [7:0] abs_exponent;
logic extra_leading_zero_bit_for_exact_power_of_two;
logic [3:0] leading_zeros;
logic [7:0] result_exponent;
logic [22:0] result_mantissa;

assign exponent = a[30:23];
assign abs_exponent = (exponent > 126) ? exponent - 127 : 127 - exponent;

assign result_exponent = 126 + (8 - leading_zeros);
assign result_mantissa = abs_exponent << (leading_zeros + 16);

always @(posedge clk)
  out_valid <= in_valid;
  
always @(posedge clk)
  if (abs_exponent == 0)
    c <= 0;
  else
    if (a[30:23] > 126)
      c <= {1'b0,result_exponent,result_mantissa};
    else
      c <= {1'b1,result_exponent,result_mantissa};
      
leading_zero_count #(.WIDTH(8))
leading_zero_count1
(
.a(abs_exponent),
.c({extra_leading_zero_bit_for_exact_power_of_two,leading_zeros})
);      
      
endmodule
