`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/10/2020 07:57:22 AM
// Design Name: 
// Module Name: complex_add
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


module complex_add
#(parameter BITS = 16, PRECISION = "COMPLEX")
(
input rstn,
input clk,
input in_valid,
input [BITS-1:0] a,
input [BITS-1:0] b,
output out_valid,
output [BITS-1:0] c
);

if (PRECISION != "COMPLEX")
begin
add
#(.BITS(BITS/2), .PRECISION(PRECISION))
add_real
(
.rstn,
.clk,
.in_valid,
.a(a[BITS-1:BITS/2]),
.b(b[BITS-1:BITS/2]),
.out_valid,
.c(c[BITS-1:BITS/2])
);

add
#(.BITS(BITS/2), .PRECISION(PRECISION))
add_imag
(
.rstn,
.clk,
.in_valid,
.a(a[BITS/2-1:0]),
.b(b[BITS/2-1:0]),
.out_valid(),
.c(c[BITS/2-1:0])
);
end

endmodule
