`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2018 10:31:09 AM
// Design Name: 
// Module Name: half_multiply
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


module half_multiply(
input rstn,
input clk,
input in_valid,
input [15:0] a,
input [15:0] b,
output reg out_valid,
output reg [15:0] c
);

reg [21:0] temp;
reg sign;
reg [5:0] exp;
reg in_valid_d;

wire [5:0] exp_minus_E;
wire [5:0] exp_minus_F;

always @(posedge clk)
  in_valid_d <= in_valid;
  
always @(posedge clk)
  out_valid <= in_valid_d;

always @(posedge clk)
  if ((a[14:0] == 0) | (b[14:0]==0))
    temp <= 0;
  else
    temp <= {10'b1,a[9:0]} * {10'b1,b[9:0]};

always @(posedge clk)
  if ((a[14:0] == 0) | (b[14:0]==0))
    sign <= 0;
  else
    sign <= a[15] ^ b[15];

always @(posedge clk)
  if (!rstn)
    c[15] <= 0;
  else
    c[15] <= sign;
    
always @(posedge clk)
  exp <= {1'b0,a[14:10]} + {1'b0,b[14:10]};
  
assign exp_minus_E = exp - 6'h0E;
assign exp_minus_F = exp - 6'h0F;
    
always @(posedge clk)
  if (!rstn)
    c[14:10] <= 0;
  else
    if (temp[21])
      c[14:10] <= (exp < 5'he) ? 5'h0 : (exp > (6'b011111 + 6'h0E)) ? 5'b11111 : exp_minus_E[4:0]; 
    else
      if (temp == 0)
        c[14:10] <= 0;
      else
        c[14:10] <= (exp < 5'hf) ? 5'h0 : (exp > (6'b011111 + 6'h0F)) ? 5'b11111 : exp_minus_F[4:0];    
    
always @(posedge clk)
  if (!rstn)
    c[9:0] <= 0;
  else
    if (temp[21])
      c[9:0] <= (exp < 5'hE) ? 10'h0 : (exp > (6'b011111 + 6'h0E)) ? 10'h3FF : temp  >> 11;
    else
      c[9:0] <= (exp < 5'hF) ? 10'h0 : (exp > (6'b011111 + 6'h0F)) ? 10'h3FF : temp  >> 10;

endmodule
