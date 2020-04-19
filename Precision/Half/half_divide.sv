`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2018 10:14:56 AM
// Design Name: 
// Module Name: half_divide
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


module half_divide(
input rstn,
input clk,
input in_valid,
input [15:0] a,
input [15:0] b,
output out_valid,
output [15:0] c
);

reg c_sign;
reg [4:0] c_exp;
wire [9:0] c_mantissa;
wire c_sign_d;
wire [4:0] c_exp_d;
wire [4:0] c_exp_corrected;
wire [21:0] quotient;
wire [4:0] leading_zeros;
wire extra_leading_zero_bit_for_exact_power_of_two;
wire [10:0] a_in;
wire [10:0] b_in;
wire a_zero;
wire b_zero;

assign a_zero = a[14:10] == 0;
assign b_zero = b[14:10] == 0;

assign a_in = (a_zero) ?
                0 :
                {1'b1,a[9:0]};
assign b_in = (b_zero) ?
                0 :
                {1'b1,b[9:0]};
                
assign c = {c_sign_d,c_exp_corrected,c_mantissa};          

assign c_mantissa = (leading_zeros == 22) ?
                        0 :
                        (leading_zeros == 10) ?
                        quotient >> 1 :
                        quotient << leading_zeros - 11;
                        
assign c_exp_corrected = (leading_zeros == 22) ?
                        0 :
                        c_exp_d - (leading_zeros - 10);
                                
always @(posedge clk)
  if (!rstn)
    c_sign <= 0;
  else
    c_sign = a[15] ^ b[15];
 
always @(posedge clk)
      if (!rstn)
        c_exp <= 0;
      else
        c_exp <= (!a_zero & !b_zero) ?
            15 + a[14:10] - b[14:10] :
            0;  
        
integer_divide
#(
.WIDTH(22)
)
integer_divide1
(
.rstn(rstn),
.clk(clk),
.in_valid(in_valid),
.dividend({a_in,11'b0}),
.divisor({11'b0,b_in}),
.out_valid(out_valid),
.quotient(quotient),
.remainder()
);

leading_zero_count #(.WIDTH(22))
leading_zero_count1
(
.a(quotient),
.c({extra_leading_zero_bit_for_exact_power_of_two,leading_zeros})
);    

delay #(.DELAY(24), .WIDTH(1))
delay_sign1
(
.rstn(rstn),
.clk(clk),
.a(c_sign),
.c(c_sign_d)
); 

delay #(.DELAY(23), .WIDTH(5))
delay_exp1
(
.rstn(rstn),
.clk(clk),
.a(c_exp),
.c(c_exp_d)
);   

endmodule
