`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/14/2019 12:30:41 AM
// Design Name: 
// Module Name: single_max_abs
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


module single_max_abs(
input rstn,
input clk,
input in_valid,
input [31:0] a,
input [31:0] b,
output reg out_valid,
output reg b_max,
output reg max_sign,
output reg [31:0] c
);

always @(posedge clk)
  out_valid <= in_valid;

always @(posedge clk)
  c[31] <= 0;
  
always @(posedge clk)
  if (!rstn)
    c[30:0] <= 0;
  else
    c[30:0] <= (a[30:23] > b[30:23]) ?
             a[30:0] :
             (b[30:23] > a[30:23]) ? 
                b[30:0] :
               (b[22:0] > a[22:0]) ?
                    b[30:0] :
                    a[30:0] ;  
                    
always @(posedge clk)
  if (!rstn)
    max_sign <= 0;
  else
    max_sign  <= (a[30:23] > b[30:23]) ?
             a[31] :
             (b[30:23] > a[30:23]) ? 
                b[31] :
               (b[22:0] > a[22:0]) ?
                    b[31] :
                    a[31] ;                      

always @(posedge clk)
  if (!rstn)
    b_max <= 0;
  else
    b_max <= (a[30:23] > b[30:23]) ?
                0 :
                (b[30:23] > a[30:23]) ? 
                    1 :
                    (b[22:0] > a[22:0]) ?
                        1 :
                        0 ;  


endmodule
