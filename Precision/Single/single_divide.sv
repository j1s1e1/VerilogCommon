`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2018 12:29:09 AM
// Design Name: 
// Module Name: single_divide
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


module single_divide(
input rstn,
input clk,
input in_valid,
input [31:0] a,
input [31:0] b,
output out_valid,
output [31:0] c
);

reg c_sign;
reg [7:0] c_exp;
wire [22:0] c_mantissa;
wire c_sign_d;
wire [7:0] c_exp_d;
wire [7:0] c_exp_corrected;
wire [47:0] quotient;
wire [6:0] leading_zeros;
wire [23:0] a_in;
wire [23:0] b_in;
wire a_zero;
wire b_zero;

assign a_zero = a[30:23] == 0;
assign b_zero = b[30:23] == 0;

assign a_in = (a_zero) ?
                0 :
                {1'b1,a[22:0]};
assign b_in = (b_zero) ?
                0 :
                {1'b1,b[22:0]};
                
assign c = {c_sign_d,c_exp_corrected,c_mantissa};          

assign c_mantissa = (leading_zeros == 48) ?
                        0 :
                        (leading_zeros == 23) ?
                        quotient >> 1 :
                        quotient << leading_zeros - 24;
                        
assign c_exp_corrected = (leading_zeros == 48) ?
                        0 :
                        c_exp_d - (leading_zeros - 23);
                                
always @(posedge clk)
  if (!rstn)
    c_sign <= 0;
  else
    c_sign = a[31] ^ b[31];
 
always @(posedge clk)
      if (!rstn)
        c_exp <= 0;
      else
        c_exp <= (!a_zero & !b_zero) ?
            127 + a[30:23] - b[30:23] :
            0;  
        
integer_divide
#(
.WIDTH(48)
)
integer_divide1
(
.rstn(rstn),
.clk(clk),
.in_valid(in_valid),
.dividend({a_in,24'b0}),
.divisor({24'b0,b_in}),
.out_valid(out_valid),
.quotient(quotient),
.remainder()
);

leading_zero_count #(.WIDTH(48))
leading_zero_count1
(
.a(quotient),
.c(leading_zeros)
);    

delay #(.DELAY(50), .WIDTH(1))
delay_sign1
(
.rstn(rstn),
.clk(clk),
.a(c_sign),
.c(c_sign_d)
); 

delay #(.DELAY(49), .WIDTH(8))
delay_exp1
(
.rstn(rstn),
.clk(clk),
.a(c_exp),
.c(c_exp_d)
);   

endmodule
