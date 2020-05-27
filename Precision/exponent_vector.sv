`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/12/2019 07:53:43 PM
// Design Name: 
// Module Name: exponent_vector
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


module exponent_vector
#(parameter BITS = 16, PRECISION = "HALF", N = 3)
(
input clk,
input in_valid,
input [BITS-1:0] a[N],
output out_valid,
output [BITS-1:0] c[N]
);

logic out_valid_array[N];
assign out_valid = out_valid_array[0];

for (genvar g = 0; g < N; g++)
  begin
    exponent
    #(.BITS(BITS), .PRECISION(PRECISION))
    exponent_array
    (
        .rstn(1'b1),
        .clk,
        .in_valid,
        .a(a[g]),
        .out_valid(out_valid_array[g]),
        .c(c[g])
    );
  end

endmodule