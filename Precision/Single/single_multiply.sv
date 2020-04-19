`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2018 01:45:47 AM
// Design Name: 
// Module Name: single_multiply
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


module single_multiply(
input rstn,
input clk,
input in_valid,
input [31:0] a,
input [31:0] b,
output logic out_valid = 0,
output logic [31:0] c = 0
);

logic [47:0] temp = 0;
logic sign = 0;
logic [7:0] exp = 0;
logic in_valid_d = 0;

always @(posedge clk)
  in_valid_d <= in_valid;
  
always @(posedge clk)
  out_valid <= in_valid_d;

always @(posedge clk)
  if ((a[30:0] == 0) | (b[30:0]==0))
    temp <= 0;
  else
    temp <= {23'b1,a[22:0]} * {23'b1,b[22:0]};

always @(posedge clk)
  if ((a[30:0] == 0) | (b[30:0]==0))
    sign <= 0;
  else
    sign <= a[31] ^ b[31];

always @(posedge clk)
  if (!rstn)
    c[31] <= 0;
  else
    c[31] <= sign;
    
always @(posedge clk)
  exp <= a[30:23] + b[30:23];
    
always @(posedge clk)
  if (!rstn)
    c[30:23] <= 0;
  else
    if (temp[47])
      c[30:23] <= exp - 8'h7E; 
    else
      if (temp == 0)
        c[30:23] <= 0;
      else
        c[30:23] <= exp - 8'h7F;    
    
always @(posedge clk)
  if (!rstn)
    c[22:0] <= 0;
  else
    if (temp[47])
      c[22:0] <= temp  >> 24;
    else
      c[22:0] <= temp  >> 23;

endmodule
