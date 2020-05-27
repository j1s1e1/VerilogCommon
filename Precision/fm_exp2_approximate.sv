`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/08/2020 12:41:10 AM
// Design Name: 
// Module Name: fm_exp2_approximate
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


module fm_exp2_approximate
#(parameter BITS = 31, PRECISION = "HALF", POLY_DEGREE = 3)
(
input rstn,
input clk,
input in_valid,
input [BITS-1:0] a,
output out_valid,
output logic [BITS-1:0] c
);

// Should be constant for float types since approximation eliminates division
localparam EPART_DELAY = 5;
  
logic [BITS-1:0] a_d;
logic [BITS-1:0] a_d2;

logic [BITS-1:0] ipart;
logic [BITS-1:0] fpart;
logic [BITS-1:0] epart;
logic [BITS-1:0] x;
logic [BITS-1:0] epart_d;

logic [BITS-1:0] pos_one_half;
logic [BITS-1:0] neg_one_half;
logic [BITS-1:0] pos_or_neg_one_half;
logic [BITS-1:0] a_plus_or_minus_one_half;  

logic out_valid_sa1; 
logic out_valid_ips;
logic out_valid_sa2;
logic out_valid_pae;
logic out_valid_2ips;
logic out_valid_epart_d;
                            
assign pos_or_neg_one_half = (a[BITS-1]) ?
        neg_one_half : // $shortrealtobits(-0.5) :
        pos_one_half;  // $shortrealtobits(0.5);            
        
always @(posedge clk)
  a_d <= a;                                                                                     

always @(posedge clk)
  a_d2 <= a_d;                 

set_value
#(.BITS(BITS), .PRECISION(PRECISION), .VALUE("PLUS_HALF"))
set_value_pos_one_half
(
.value(pos_one_half)
); 

set_value
#(.BITS(BITS), .PRECISION(PRECISION), .VALUE("MINUS_HALF"))
set_value_neg_one_half
(
.value(neg_one_half)
);     

add
#(.BITS(BITS), .PRECISION(PRECISION))
add1
(
.rstn(rstn),
.clk(clk),
.in_valid(in_valid),
.a(a),
.b(pos_or_neg_one_half),
.out_valid(out_valid_sa1),
.c(a_plus_or_minus_one_half)
);
                              
integer_part
#(.BITS(BITS), .PRECISION(PRECISION))
integer_part1
(
.rstn(rstn),
.clk(clk),
.in_valid(out_valid_sa1),
.a(a_plus_or_minus_one_half),
.out_valid(out_valid_ips),
.c(ipart)
); 

add 
#(.BITS(BITS), .PRECISION(PRECISION))
add2
(
.rstn(rstn),
.clk(clk),
.in_valid(out_valid_ips),
.a(a_d2),
.b({~ipart[BITS-1],ipart[BITS-2:0]}),
.out_valid(out_valid_sa2),
.c(fpart)
);

two_int_power
#(.BITS(BITS), .PRECISION(PRECISION))
two_int_power1
(
.rstn(rstn),
.clk(clk),
.in_valid(out_valid_ips),
.a(ipart),
.out_valid(out_valid_2ips),
.c(epart)
);

poly_approximate_exp 
#(.BITS(BITS), .PRECISION(PRECISION), .DEGREE(POLY_DEGREE))
poly_approximate_exp1
(
.rstn(rstn),
.clk(clk),
.in_valid(out_valid_sa2),
.fpart(fpart),
.out_valid(out_valid_pae),
.x(x)
);

delay #(.DELAY(EPART_DELAY), .WIDTH(BITS))
delay_epart
(
.rstn(rstn),
.clk(clk),
.a(epart),
.c(epart_d)
); 

delay #(.DELAY(EPART_DELAY), .WIDTH(1))
delay_outv
(
.rstn(rstn),
.clk(clk),
.a(out_valid_2ips),
.c(out_valid_epart_d)
); 

multiply 
#(.BITS(BITS), .PRECISION(PRECISION))
multiply1
(
.rstn(rstn),
.clk(clk),
.in_valid(out_valid_epart_d),
.a(epart_d),
.b(x),
.out_valid(out_valid),
.c
);

endmodule
