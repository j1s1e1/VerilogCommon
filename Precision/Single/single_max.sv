`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2018 01:16:02 AM
// Design Name: 
// Module Name: single_max
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


module single_max
(
input rstn,
input clk,
input in_valid,
input [31:0] a,
input [31:0] b,
output reg out_valid,
output reg b_max,
output reg [31:0] c
);

always @(posedge clk)
  out_valid <= in_valid;

always @(posedge clk)
  if (!rstn)
    c <= 0;
  else
    c <= (a[31] != b[31]) ?
                // Different signs
                (a[31] == 1'b0) ?
                    a :
                    b :
                (a[31] == 1'b0) ?
                    // Both positive
                    (a[30:23] > b[30:23]) ?
                        a :
                        (b[30:23] > a[30:23]) ? 
                            b :
                                (a[22:0] > b[22:0]) ?
                                a :
                                b :
                    // Both negative
                    (a[30:23] > b[30:23]) ?
                        b :
                        (b[30:23] > a[30:23]) ? 
                            a :
                                (a[22:0] > b[22:0]) ?
                                b :
                                a ;  
                                
always @(posedge clk)
  if (!rstn)
    b_max <= 0;
  else
    b_max <= (a[31] != b[31]) ?
                // Different signs
                (a[31] == 1'b0) ?
                    0 :
                    1 :
                (a[31] == 1'b0) ?
                    // Both positive
                    (a[30:23] > b[30:23]) ?
                        0 :
                        (b[30:23] > a[30:23]) ? 
                            1 :
                                (a[22:0] > b[22:0]) ?
                                0 :
                                1 :
                    // Both negative
                    (a[30:23] > b[30:23]) ?
                        1 :
                        (b[30:23] > a[30:23]) ? 
                            0 :
                                (a[22:0] > b[22:0]) ?
                                1 :
                                0 ;                                                                
endmodule
