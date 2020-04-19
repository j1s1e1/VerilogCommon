`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2018 08:22:08 AM
// Design Name: 
// Module Name: half_add
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


module half_add(
input rstn,
input clk,
input in_valid,
input [15:0] a,
input [15:0] b,
output reg out_valid,
output wire [15:0] c
);

localparam SUM_SHIFT = 24 - 12;

reg [15:0] c_int;

wire [23:0] sum;

wire a_zero;
wire b_zero;
wire expa_gt_expb;
wire expb_gt_expa;
wire mana_gt_manb;
wire manb_gt_mana;
wire a_gt_b;
wire [3:0] ashift;
wire [3:0] bshift;
wire minus;
wire extra_leading_zero_bit_for_exact_power_of_two;
wire [4:0] leading_zeros;

assign c = c_int;

assign a_zero = (a[14:10] == 5'b0) ? 1 : 0; 
assign b_zero = (b[14:10] == 5'b0) ? 1 : 0;     
assign expa_gt_expb = (a[14:10] > b[14:10]) ? 1 : 0;
assign expb_gt_expa = (b[14:10] > a[14:10]) ? 1 : 0;
assign mana_gt_manb = (a[9:0] > b[9:0]) ? 1 : 0;
assign manb_gt_mana = (b[9:0] > a[9:0]) ? 1 : 0;
assign a_gt_b = (expa_gt_expb | (!expb_gt_expa & mana_gt_manb));
assign ashift = expb_gt_expa ? 
                    (b[14:10] - a[14:10] < 11) ? b[14:10] - a[14:10] : 11
                    : 0;
assign bshift = expa_gt_expb ? 
                    (a[14:10] - b[14:10] < 11) ? a[14:10] - b[14:10] : 11                     
                    : 0;                    
assign minus = ((a[15] != b[15]) & (!a_zero & !b_zero));  

always @(posedge clk)
  out_valid <= in_valid;                    

always @(posedge clk)
  if (!rstn)
    c_int[15] <= 0;
  else
    c_int[15] <= (a[15] == b[15]) ? a[15] :
             expa_gt_expb ? a[15] :
             expb_gt_expa ? b[15] :
             mana_gt_manb ? a[15] : 
             manb_gt_mana ? b[15] : 0;
             
always @(posedge clk)
  if (!rstn)
    c_int[14:10] <= 0;
  else             
    c_int[14:10] <= (leading_zeros < 20) ?
                    expb_gt_expa ?
                    b[14:10] + (5'b1 - leading_zeros):
                    a[14:10] + (5'b1 - leading_zeros):
                    0;
                
always @(posedge clk)
  if (!rstn)
    c_int[9:0] <= 0;
  else
    c_int[9:0] <= (leading_zeros < 24) ?
                       (leading_zeros < 13) ?
                            sum >> (13 - leading_zeros):
                            sum << (leading_zeros - 13): 
                       0;

assign sum = (minus) ?
                (a_gt_b) ?
                    ({1'b1,a[9:0]} << (SUM_SHIFT - ashift)) - ({1'b1,b[9:0]} << (SUM_SHIFT - bshift)) :
                    ({1'b1,b[9:0]} << (SUM_SHIFT - bshift)) - ({1'b1,a[9:0]} << (SUM_SHIFT - ashift)) :
                (a_zero) ?
                    (b_zero) ?
                         0 :
                    ({1'b1,b[9:0]} << (SUM_SHIFT - bshift)) :
                (b_zero) ?
                    ({1'b1,a[9:0]} << (SUM_SHIFT - ashift)) :
                    ({1'b1,a[9:0]} << (SUM_SHIFT - ashift)) + ({1'b1,b[9:0]} << (SUM_SHIFT - bshift));            

leading_zero_count #(.WIDTH(24))
leading_zero_count1
(
.a(sum),
.c({extra_leading_zero_bit_for_exact_power_of_two,leading_zeros})
);

endmodule
