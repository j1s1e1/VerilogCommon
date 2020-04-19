`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2019 02:35:23 PM
// Design Name: 
// Module Name: fixed_divide
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


module fixed_divide
#(parameter BITS = 8, PRECISION = "FIXED_04_04")
(
input clk,
input in_valid,
input signed [BITS-1:0] a,
input signed [BITS-1:0] b,
output reg out_valid,
output reg signed [BITS-1:0] c
);

parameter FRACTION = 10 * (PRECISION[15:8] - 8'h30) + PRECISION[7:0] - 8'h30;

logic [BITS-2:0] abs_a;
logic [BITS-2:0] abs_b;
logic [BITS-2+FRACTION:0] abs_a_extended;
logic [BITS-2+FRACTION:0] abs_b_extended;
logic [BITS-2+FRACTION:0] quotient;
logic [BITS-2+FRACTION:0] signed_quotient;
logic [BITS-2+FRACTION:0] remainder;
logic sign, sign_d;

assign abs_a = (a[BITS-1] == 0) ? a[BITS-2:0] : ~a[BITS-2:0] + 1'b1;
assign abs_b = (b[BITS-1] == 0) ? b[BITS-2:0] : ~b[BITS-2:0] + 1'b1;
assign abs_a_extended = {abs_a, {(FRACTION){1'b0}}};
assign abs_b_extended = {{(FRACTION){1'b0}},abs_b};
assign sign = (a[BITS-1] == b[BITS-1]) ? 0 : 1;
assign signed_quotient = (sign_d == 0) ?  quotient : ~quotient + 1'b1;
assign c = {sign_d,signed_quotient[BITS-2:0]};

delay #(.DELAY(BITS+FRACTION+1), .WIDTH(1))
 delay_sign
 (
 .rstn(1'b1),
 .clk(clk),
 .a(sign),
 .c(sign_d)
 ); 

integer_divide
#(.WIDTH(BITS+FRACTION-1))
integer_divide1
(
.rstn(1'b1),
.clk,
.in_valid,
.dividend(abs_a_extended),
.divisor(abs_b_extended),
.out_valid,
.quotient,
.remainder
);

endmodule
