`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/12/2019 09:21:47 PM
// Design Name: 
// Module Name: half_max_abs
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


module half_max_abs(
input rstn,
input clk,
input in_valid,
input [15:0] a,
input [15:0] b,
output reg out_valid,
output reg b_max,
output reg max_sign,
output reg [15:0] c
);

always @(posedge clk)
  out_valid <= in_valid;

always @(posedge clk)
  c[15] <= 0;
  
always @(posedge clk)
  if (!rstn)
    c[14:0] <= 0;
  else
    c[14:0] <= (a[14:10] > b[14:10]) ?
             a[14:0] :
             (b[14:10] > a[14:10]) ? 
                b[14:0] :
               (b[9:0] > a[9:0]) ?
                    b[14:0] :
                    a[14:0] ;  
                    
always @(posedge clk)
  if (!rstn)
    max_sign <= 0;
  else
    max_sign <= (a[14:10] > b[14:10]) ?
             a[15] :
             (b[14:10] > a[14:10]) ? 
                b[15] :
               (b[9:0] > a[9:0]) ?
                    b[15] :
                    a[15] ;                      

always @(posedge clk)
  if (!rstn)
    b_max <= 0;
  else
    b_max <= (a[14:10] > b[14:10]) ?
                0 :
                (b[14:10] > a[14:10]) ? 
                    1 :
                    (b[9:0] > a[9:0]) ?
                        1 :
                        0 ;  
                                                    
endmodule
