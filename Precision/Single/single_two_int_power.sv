`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2018 02:21:34 AM
// Design Name: 
// Module Name: single_two_int_power
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


module single_two_int_power(
input rstn,
input clk,
input in_valid,
input [31:0] a,
output reg out_valid = 0,
output reg [31:0] c = 0
);

wire [7:0] exp;

assign exp = (a[30:23] > 126) ?
                (a[31]) ?
                    127 - ({1'b1,a[22:0]} >> (24 - (a[30:23] - 126) )) :
                    127 + ({1'b1,a[22:0]} >> (24 - (a[30:23] - 126) )) :
                127;
                
 always @(posedge clk)
   if (!rstn)     
     out_valid <= 0;
   else
     out_valid <= in_valid;          

always @(posedge clk)
  if (!rstn)
    c <= 0;
  else
    c <= {1'b0, exp , 23'b0 };

endmodule
