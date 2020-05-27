`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/02/2020 04:41:28 PM
// Design Name: 
// Module Name: log2
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


module log2
#(BITS = 16, PRECISION = "HALF")
(
input clk,
input in_valid,
input [BITS-1:0] a,
output out_valid,
output [BITS-1:0] c
);

// Difference is time for divide
localparam POWER_2_PART_DELAY = (PRECISION == "HALF") ? 23 + 6 : 49 + 6;

logic [BITS-1:0] a_zero_exponent;
logic [BITS-1:0] power_2_part;
logic [BITS-1:0] power_2_part_d;
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

pade_log2
#(.BITS(BITS), .PRECISION(PRECISION))
pade_log2_1
(
.clk,
.in_valid,
.a(a_zero_exponent),
.out_valid(out_valid_pade_log2),
.c(one_to_2_part)
);

delay #(.DELAY(POWER_2_PART_DELAY), .WIDTH(BITS))
delay_sign1
(
.rstn(1'b1),
.clk(clk),
.a(power_2_part),
.c(power_2_part_d)
); 

add
#(.BITS(BITS), .PRECISION(PRECISION))
add_results
(
.rstn(1'b1),
.clk,
.in_valid(out_valid_pade_log2),
.a(power_2_part_d),
.b(one_to_2_part),
.out_valid,
.c
);

endmodule
