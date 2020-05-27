`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/14/2019 06:41:00 PM
// Design Name: 
// Module Name: clip
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


module clip
#(parameter BITS = 16, PRECISION = "HALF")
(
input [BITS-1:0] a,
input [BITS-1:0] min,
input [BITS-1:0] max,
output logic [BITS-1:0] c
);

logic a_greater_than_min;
logic a_less_than_max;

assign c = (a_greater_than_min) ? 
			(a_less_than_max) ?
				a :
				max :
			min;

greater_than
#(.BITS(BITS), .PRECISION(PRECISION))
greater_than1
(
.a(a),
.b(min),
.a_gt_b(a_greater_than_min)
);

less_than
#(.BITS(BITS), .PRECISION(PRECISION))
less_than1
(
.a(a),
.b(max),
.a_lt_b(a_less_than_max)
);

endmodule
