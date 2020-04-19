`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/25/2020 07:44:54 PM
// Design Name: 
// Module Name: single_accum_add_sub
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


module single_accum_add_sub
(
input clk,
input in_valid,
input [31:0] a,
input [31:0] b,
input [31:0] c,
output logic out_valid = 0,
output logic [31:0] d
);

localparam SUM_SHIFT = 40 - 25;

logic [31:0] d_int = 0;
logic [39:0] sum;
logic [39:0] minus_sum;
logic [39:0] abs_sum;
logic [39:0] two_c_a;
logic [39:0] two_c_b;
logic [39:0] two_c_c;

logic [7:0] max_exp;
logic [5:0] leading_zeros;

assign d = (out_valid) ? d_int : 0;
    
assign max_exp = (a[30:23] > b[30:23]) ? (a[30:23] > c[30:23]) ? a[30:23] : c[30:23]:
                                         (b[30:23] > c[30:23]) ? b[30:23] : c[30:23];

always @(posedge clk)
  out_valid <= in_valid;                    

single_to_2c single_to_2c_a
(
.single(a),
.max_exp,
.two_c(two_c_a)
);

single_to_2c single_to_2c_b
(
.single(b),
.max_exp,
.two_c(two_c_b)
);

single_to_2c single_to_2c_c
(
.single({~c[31],c[30:0]}),
.max_exp,
.two_c(two_c_c)
);

assign sum = two_c_a + two_c_b + two_c_c;
assign minus_sum = -two_c_a - two_c_b - two_c_c;
assign abs_sum = (sum[39]) ? minus_sum : sum;

always @(posedge clk)
   d_int[31] = sum[39];             
always @(posedge clk)
   d_int[30:23] <= (leading_zeros < 40) ?
                    max_exp + (8'd2 - leading_zeros):
                    0;
                
always @(posedge clk)
    d_int[22:0] <= (leading_zeros < 40) ?
                        (leading_zeros < 16) ?
                            abs_sum >> (16 - leading_zeros):
                            abs_sum << (leading_zeros - 16): 
                        0;

leading_zero_count #(.WIDTH(40))
leading_zero_count1
(
.a(abs_sum),
.c(leading_zeros)
);      
endmodule
