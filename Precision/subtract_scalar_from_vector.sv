`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/12/2019 07:53:43 PM
// Design Name: 
// Module Name: subtract_scalar_from_vector
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


module subtract_scalar_from_vector
#(parameter BITS = 16, PRECISION = "HALF", N = 3)
(
input clk,
input in_valid,
input [BITS-1:0] a[N],
input [BITS-1:0] b,
output out_valid,
output [BITS-1:0] c[N]
);

logic out_valid_array[N];
assign out_valid = out_valid_array[0];

for (genvar g = 0; g < N; g++)
  begin
    subtract
    #(.BITS(BITS), .PRECISION(PRECISION))
    subtract_array
    (
        .rstn(1'b1),
        .clk,
        .in_valid,
        .a(a[g]),
        .b(b),
        .out_valid(out_valid_array[g]),
        .c(c[g])
    );
  end

endmodule
