`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/12/2019 07:53:43 PM
// Design Name: 
// Module Name: add_vector
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


module add_vector
#(parameter BITS = 16, PRECISION = "HALF", N = 3)
(
input clk,
input in_valid,
input [BITS-1:0] a[N],
input [BITS-1:0] b[N],
output out_valid,
output [BITS-1:0] c[N]
);

logic out_valid_array[N];

assign out_valid = out_valid_array[0];

for (genvar g = 0; g < N; g++)
  add
  #(.BITS(BITS), .PRECISION(PRECISION))
  add_array
  (
  .rstn(1'b1),
  .clk,
  .in_valid,
  .a(a[g]),
  .b(b[g]),
  .out_valid(out_valid_array[g]),
  .c(c[g])
  );

endmodule
