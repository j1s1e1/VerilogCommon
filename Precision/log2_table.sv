`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/13/2020 06:24:41 PM
// Design Name: 
// Module Name: log2_table
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


module log2_table
#(BITS = 16, PRECISION = "HALF", STEPS = 16)
(
input clk,
input in_valid,
input [BITS-1:0] a,
output out_valid,
output [BITS-1:0] c
);

//  Could use tables for all of
//      Exponent to Ln of Exponent Float    This is probably more efficient to calculate
//      Log2 of 1.00000 to 1.999999...

logic [BITS-1:0] a_zero_exponent;
logic [BITS-1:0] power_2_part;
logic [BITS-1:0] one_to_2_part;

logic out_valid_pade_log2;

base2_exp
#(.BITS(BITS), .PRECISION(PRECISION))
base2_exp1
(
.clk,
.in_valid,
.a,
.out_valid(),
.c(power_2_part)
);

base_2_zero_exponent
#(.BITS(BITS), .PRECISION(PRECISION))
base_2_zero_exponent1
(    
.a,
.c(a_zero_exponent)
);

log2_table_one_to_two
#(.BITS(BITS), .PRECISION(PRECISION), .STEPS(STEPS))
log2_table_one_to_two1
(
.clk,
.in_valid,
.a(a_zero_exponent),
.out_valid(out_valid_pade_log2),
.c(one_to_2_part)
);

add
#(.BITS(BITS), .PRECISION(PRECISION))
add_results
(
.rstn(1'b1),
.clk,
.in_valid(out_valid_pade_log2),
.a(power_2_part),
.b(one_to_2_part),
.out_valid,
.c
);

endmodule
