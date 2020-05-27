`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/14/2020 09:07:23 PM
// Design Name: 
// Module Name: deinterleave_block_output_vector
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


module deinterleave_block_output_vector
#(BITS = 8, IIR = 3, N = 10, V = 2)
(
input clk,
input in_valid,
input [BITS-1:0] data_in[V],
output logic out_valid,
output logic [BITS-1:0] data_out[V]
);

logic out_valid_array[V];

assign out_valid = out_valid_array[0];

for (genvar g = 0; g < V; g++)
deinterleave_block_output
#(.BITS(BITS), .IIR(IIR), .N(N))
deinterleave_block_output_array
(
.clk,
.in_valid,
.data_in(data_in[g]),
.out_valid(out_valid_array[g]),
.data_out(data_out[g])
);

endmodule
