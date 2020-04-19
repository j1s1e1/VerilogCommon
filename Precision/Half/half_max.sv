`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2018 03:03:05 PM
// Design Name: 
// Module Name: half_max
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


module half_max(
input rstn,
input clk,
input in_valid,
input [15:0] a,
input [15:0] b,
output reg out_valid,
output reg b_max,
output reg [15:0] c
);

always @(posedge clk)
  out_valid <= in_valid;

always @(posedge clk)
  if (!rstn)
    c <= 0;
  else
    c <= (a[15] != b[15]) ?
                // Different signs
                (a[15] == 1'b0) ?
                    a :
                    b :
                (a[15] == 1'b0) ?
                    // Both positive
                    (a[14:10] > b[14:10]) ?
                        a :
                        (b[14:10] > a[14:10]) ? 
                            b :
                                (a[9:0] > b[9:0]) ?
                                a :
                                b :
                    // Both negative
                    (a[14:10] > b[14:10]) ?
                        b :
                        (b[14:10] > a[14:10]) ? 
                            a :
                                (a[9:0] > b[9:0]) ?
                                b :
                                a ;   
                                
always @(posedge clk)
  if (!rstn)
    b_max <= 0;
  else
    b_max <= (a[15] != b[15]) ?
                // Different signs
                (a[15] == 1'b0) ?
                    0 :
                    1 :
                (a[15] == 1'b0) ?
                    // Both positive
                    (a[14:10] > b[14:10]) ?
                        0 :
                        (b[14:10] > a[14:10]) ? 
                            1 :
                                (a[9:0] > b[9:0]) ?
                                0 :
                                1 :
                    // Both negative
                    (a[14:10] > b[14:10]) ?
                        1 :
                        (b[14:10] > a[14:10]) ? 
                            0 :
                                (a[9:0] > b[9:0]) ?
                                1 :
                                0 ;                                                                
endmodule
