`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/14/2020 09:04:07 PM
// Design Name: 
// Module Name: interleave_block_input_vector
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


module interleave_block_input_vector
#(BITS = 8, IIR = 3, N = 10, V = 2)
(
input clk,
input in_valid,
input [BITS-1:0] data_in[V],
output logic out_valid,
output logic block_start,
output logic [BITS-1:0] data_out[V]
);

logic out_valid_array[V];
logic block_start_array[V];

assign out_valid = out_valid_array[0];
assign block_start = block_start_array[0];

for (genvar g = 0; g < V; g++)
interleave_block_input
#(.BITS(BITS), .IIR(IIR), .N(N))
interleave_block_input_array
(
.clk,
.in_valid,
.data_in(data_in[g]),
.out_valid(out_valid_array[g]),
.block_start(block_start_array[g]),
.data_out(data_out[g])
);

endmodule
