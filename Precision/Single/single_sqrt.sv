`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/20/2018 11:33:38 PM
// Design Name: 
// Module Name: single_sqrt
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


module single_sqrt(
input rstn,
input clk,
input in_valid,
input [31:0] a,
output out_valid,
output [31:0] c
);

wire [7:0] exp;
wire [25:0] mantissa_in;
wire [23:0] mantissa_out;

assign exp = {1'b0,a[30:24]} + 8'h3F + a[23];
assign mantissa_out[10:0] = 0;

assign mantissa_in = (a[23]) ? {2'b1,a[22:0],1'b0} : {1'b1,a[22:0],2'b0};
assign c[22:0] = (mantissa_out[23]) ? mantissa_out[22:0] : 
                 (mantissa_out[22]) ? {mantissa_out[21:0],1'b0} : {mantissa_out[20:0],2'b0};

integer_sqrt #(.WIDTH(26))
integer_sqrt1
(
.rstn(rstn),
.clk(clk),
.a(mantissa_in),
.c(mantissa_out[23:11])
);

delay #(.DELAY(15), .WIDTH(8))
delay_exp1
(
.rstn(rstn),
.clk(clk),
.a(exp),
.c(c[30:23])
);  

delay #(.DELAY(15), .WIDTH(1))
delay_sign1
(
.rstn(rstn),
.clk(clk),
.a(a[31]),
.c(c[31])
);    

delay #(.DELAY(15), .WIDTH(1))
delay_out_valid
(
.rstn(rstn),
.clk(clk),
.a(in_valid),
.c(out_valid)
);    
    
endmodule
