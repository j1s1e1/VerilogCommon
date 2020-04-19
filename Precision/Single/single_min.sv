`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2018 01:16:02 AM
// Design Name: 
// Module Name: single_min
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


module single_min
(
input rstn,
input clk,
input in_valid,
input [31:0] a,
input [31:0] b,
output reg out_valid,
output reg b_min,
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
                    b :
                    a :
                (a[31] == 1'b0) ?
                    // Both positive
                    (a[30:23] > b[30:23]) ?
                        b :
                        (b[30:23] > a[30:23]) ? 
                            a :
                                (a[22:0] > b[22:0]) ?
                                b :
                                a :
                    // Both negative
                    (a[30:23] > b[30:23]) ?
                        a :
                        (b[30:23] > a[30:23]) ? 
                            b :
                                (a[22:0] > b[22:0]) ?
                                a :
                                b ;      
                                
always @(posedge clk)
  if (!rstn)
    b_min <= 0;
  else
    b_min <= (a[31] != b[31]) ?
                // Different signs
                (a[31] == 1'b0) ?
                    1 :
                    0 :
                (a[31] == 1'b0) ?
                    // Both positive
                    (a[30:23] > b[30:23]) ?
                        1 :
                        (b[30:23] > a[30:23]) ? 
                            0 :
                                (a[22:0] > b[22:0]) ?
                                1 :
                                0 :
                    // Both negative
                    (a[30:23] > b[30:23]) ?
                        0 :
                        (b[30:23] > a[30:23]) ? 
                            1 :
                                (a[22:0] > b[22:0]) ?
                                0 :
                                1 ;  
                                                                                          
endmodule
