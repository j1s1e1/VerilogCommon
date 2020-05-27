`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/29/2019 05:22:38 PM
// Design Name: 
// Module Name: pade_approximation_exp
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
//
//  Approximates 2^fraction for values between -0.5 and +0.5
//
//////////////////////////////////////////////////////////////////////////////////


module pade_approximation_exp
#(parameter BITS = 16, PRECISION = "HALF")
(
input rstn,
input clk,
input [BITS-1:0] fpart,
output [BITS-1:0] x
);

logic [BITS-1:0] fpart_sqr;
logic [BITS-1:0] fm_exp2_q[2];
logic [BITS-1:0] fm_exp2_p[3];
logic [BITS-1:0] px,px2,px3,px4,px5;
logic [BITS-1:0] qx,qx2,qx3;
logic [BITS-1:0] qx3_m_px5;
logic [BITS-1:0] px5_d_qx3_m_px5;
logic [BITS-1:0] px5_d_qx3_m_px5_m_2;

logic [BITS-1:0] px5_d1, qx3_d4;
logic [BITS-1:0] fpart_sqr_d1, fpart_sqr_d3;
logic [BITS-1:0] fpart_d8;

logic [BITS-1:0] two;
logic [BITS-1:0] one;

set_value #(.BITS(BITS), .PRECISION(PRECISION), .VALUE("FM_EXP2_Q0"))
set_value_fm_exp2_q0 (.value(fm_exp2_q[0]));

set_value #(.BITS(BITS), .PRECISION(PRECISION), .VALUE("FM_EXP2_Q1"))
set_value_fm_exp2_q1 (.value(fm_exp2_q[1]));

set_value #(.BITS(BITS), .PRECISION(PRECISION), .VALUE("FM_EXP2_P0"))
set_value_fm_exp2_p0 (.value(fm_exp2_p[0]));

set_value #(.BITS(BITS), .PRECISION(PRECISION), .VALUE("FM_EXP2_P1"))
set_value_fm_exp2_p1 (.value(fm_exp2_p[1]));

set_value #(.BITS(BITS), .PRECISION(PRECISION), .VALUE("FM_EXP2_P2"))
set_value_fm_exp2_p2 (.value(fm_exp2_p[2]));

set_value #(.BITS(BITS), .PRECISION(PRECISION), .VALUE("PLUS_TWO"))
set_value_two (.value(two));

set_value #(.BITS(BITS), .PRECISION(PRECISION), .VALUE("PLUS_ONE"))
set_value_one (.value(one));

multiply 
#(.BITS(BITS), .PRECISION(PRECISION))
multiply1
(
.rstn(rstn),
.clk(clk),
.in_valid(1'b1),
.a(fpart),
.b(fpart),
.out_valid(),
.c(fpart_sqr)
);      

multiply 
#(.BITS(BITS), .PRECISION(PRECISION))
multiply2
(
.rstn(rstn),
.clk(clk),
.in_valid(1'b1),
.a(fm_exp2_p[0]),
.b(fpart_sqr),
.out_valid(),
.c(px)
); 

add 
#(.BITS(BITS), .PRECISION(PRECISION))
add1
(
.rstn(rstn),
.clk(clk),
.in_valid(1'b1),
.a(px),
.b(fm_exp2_p[1]),
.out_valid(),
.c(px2)
);

add 
#(.BITS(BITS), .PRECISION(PRECISION))
add2
(
.rstn(rstn),
.clk(clk),
.in_valid(1'b1),
.a(fpart_sqr),
.b(fm_exp2_q[0]),
.out_valid(),
.c(qx)
);

delay #(.DELAY(1), .WIDTH(BITS))
delay_fpart_sqr1
(
.rstn(rstn),
.clk(clk),
.a(fpart_sqr),
.c(fpart_sqr_d1)
); 

delay #(.DELAY(3), .WIDTH(BITS))
delay_fpart_sqr3
(
.rstn(rstn),
.clk(clk),
.a(fpart_sqr),
.c(fpart_sqr_d3)
); 

multiply 
#(.BITS(BITS), .PRECISION(PRECISION))
multiply3
(
.rstn(rstn),
.clk(clk),
.in_valid(1'b1),
.a(px2),
.b(fpart_sqr_d3),
.out_valid(),
.c(px3)
); 

add 
#(.BITS(BITS), .PRECISION(PRECISION))
add3
(
.rstn(rstn),
.clk(clk),
.in_valid(1'b1),
.a(px3),
.b(fm_exp2_p[2]),
.out_valid(),
.c(px4)
);

multiply 
#(.BITS(BITS), .PRECISION(PRECISION))
multiply4(
.rstn(rstn),
.clk(clk),
.in_valid(1'b1),
.a(qx),
.b(fpart_sqr_d1),
.out_valid(),
.c(qx2)
); 

add 
#(.BITS(BITS), .PRECISION(PRECISION))
add4
(
.rstn(rstn),
.clk(clk),
.in_valid(1'b1),
.a(qx2),
.b(fm_exp2_q[1]),
.out_valid(),
.c(qx3)
);

delay #(.DELAY(8), .WIDTH(BITS))
delay_fpart_8
(
.rstn(rstn),
.clk(clk),
.a(fpart),
.c(fpart_d8)
); 

multiply 
#(.BITS(BITS), .PRECISION(PRECISION))
multiply5
(
.rstn(rstn),
.clk(clk),
.in_valid(1'b1),
.a(px4),
.b(fpart_d8),
.out_valid(),
.c(px5)
); 

delay #(.DELAY(4), .WIDTH(BITS))
delay_qx3_d4
(
.rstn(rstn),
.clk(clk),
.a(qx3),
.c(qx3_d4)
); 

delay #(.DELAY(1), .WIDTH(BITS))
delay_px5_d1
(
.rstn(rstn),
.clk(clk),
.a(px5),
.c(px5_d1)
); 

add 
#(.BITS(BITS), .PRECISION(PRECISION))
add5
(
.rstn(rstn),
.clk(clk),
.in_valid(1'b1),
.a(qx3_d4),
.b({~px5[BITS-1],px5[BITS-2:0]}),
.out_valid(),
.c(qx3_m_px5)
);

divide 
#(.BITS(BITS), .PRECISION(PRECISION))
divide1
(
.rstn(rstn),
.clk(clk),
.in_valid(1'b1),
.a(px5_d1),
.b(qx3_m_px5),
.out_valid(),
.c(px5_d_qx3_m_px5)
);

multiply 
#(.BITS(BITS), .PRECISION(PRECISION))
multiply6
(
.rstn(rstn),
.clk(clk),
.in_valid(1'b1),
.a(two),
.b(px5_d_qx3_m_px5),
.out_valid(),
.c(px5_d_qx3_m_px5_m_2)
); 

add 
#(.BITS(BITS), .PRECISION(PRECISION))
add6
(
.rstn(rstn),
.clk(clk),
.in_valid(1'b1),
.a(one),
.b(px5_d_qx3_m_px5_m_2),
.out_valid(),
.c(x)
);

endmodule
