`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/14/2019 06:41:00 PM
// Design Name: 
// Module Name: greater_than
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


module greater_than
#(parameter BITS = 16, PRECISION = "HALF")
(
input [BITS-1:0] a,
input [BITS-1:0] b,
output a_gt_b
);

if (PRECISION == "SINGLE")
single_greater_than single_greater_than1
(
.a(a),
.b(b),
.a_gt_b(a_gt_b)
);

endmodule