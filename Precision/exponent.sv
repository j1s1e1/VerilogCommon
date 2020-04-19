`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/29/2019 04:47:30 PM
// Design Name: 
// Module Name: exponent
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


module exponent
#(parameter BITS = 32, PRECISION = "FIXED_16_16")
(
input rstn,
input clk,
input in_valid,
input [BITS-1:0] a,
output out_valid,
output [BITS-1:0] c
);

wire out_valid_m1;
wire [BITS-1:0] log2e;
wire [BITS-1:0] a_x_log2e;
/*
wire [BITS-1:0] a_in;

assign a_in = (a[15] == 1) ?
                 (a[14:10] > 17) ?
                    16'b1100100000000000 : // min value -8 to prevent calulation underflow
                    a :
                 (a[14:10] > 17) ?
                    16'b0100100000000000 : // max value 8 to prevent calulation overflow
                    a;
*/

set_value #(.BITS(BITS), .PRECISION(PRECISION), .VALUE("LOG2_E"))
set_value_log2e (.value(log2e));

multiply
#(.BITS(BITS), .PRECISION(PRECISION))
multiply1
(
.rstn(rstn),
.clk(clk),
.in_valid(in_valid),
.a(a),
.b(log2e),
.out_valid(out_valid_m1),
.c(a_x_log2e)
); 

fm_exp2
#(.BITS(BITS), .PRECISION(PRECISION))
fm_exp2_1
(
.rstn(rstn),
.clk(clk),
.in_valid(out_valid_m1),
.a(a_x_log2e),
.out_valid(out_valid),
.c(c)
);

endmodule
