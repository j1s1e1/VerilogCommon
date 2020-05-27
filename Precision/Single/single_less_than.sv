`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/30/2019 06:32:13 PM
// Design Name: 
// Module Name: single_less_than
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


module single_less_than(
input [31:0] a,
input [31:0] b,
output a_lt_b
);

assign a_lt_b = (a[31] != b[31]) ?
                // Different signs
                (a[31] == 1'b1) ?
                    ((a[30:0] != 0) || (b[30:0] != 0)) ? 1 : 0   :
                    0 :
                (a[31] == 1'b0) ?
                    // Both positive
                    (a[30:23] < b[30:23]) ?
                        1 :
                        (b[30:23] < a[30:23]) ? 
                            0 :
                                (a[22:0] < b[22:0]) ?
                                1 :
                                0 :
                    // Both negative
                    (a[30:23] < b[30:23]) ?
                        0 :
                        (b[30:23] < a[30:23]) ? 
                            1 :
                                (b[22:0] < a[22:0]) ?
                                1 :
                                0 ;                                
endmodule
