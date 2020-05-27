`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/12/2019 07:53:43 PM
// Design Name: 
// Module Name: subtract_matrix
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


module subtract_matrix
#(parameter BITS = 16, PRECISION = "HALF", R = 2, C = 2)
(
input clk,
input in_valid,
input [BITS-1:0] a[R][C],
input [BITS-1:0] b[R][C],
output out_valid,
output [BITS-1:0] c[R][C]
);

logic out_valid_array[R];
assign out_valid = out_valid_array[0];

for (genvar g = 0; g < R; g++)
  begin
    subtract_vector
    #(.BITS(BITS), .PRECISION(PRECISION), .N(C))
    subtract_vector_array
    (
        .clk,
        .in_valid,
        .a(a[g]),
        .b(b[g]),
        .out_valid(out_valid_array[g]),
        .c(c[g])
    );
  end

endmodule
