`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/02/2020 02:33:51 AM
// Design Name: 
// Module Name: reverse_order
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


module reverse_order
#(BITS = 8, N = 10)
(
input clk,
input in_valid,
input [BITS-1:0] data_in,
output logic out_valid = 0,
output logic [BITS-1:0] data_out = 0
);

localparam DEPTH = N + (N+1)/2;

logic [BITS-1:0] data[DEPTH];
logic [$clog2(N*2):0] count = 0;
logic [$clog2(N*2):0] out_count = 0;

always @(posedge clk)
  if (in_valid)
    if (count < (N * 2 - 1))
      count <= count + 1;
    else
      count <= 0;
  else
    count <= count;

always @(posedge clk)
  begin
    data <= data;
    if (in_valid)
      if (count < DEPTH)
        data[count] <= data_in;
      else
        data[count - N] <= data_in;
  end

always @(posedge clk)
  begin
    out_count <= out_count;
    if (out_count > 0)
      if (out_count % N == 1)
        out_count <= 0;
      else
        out_count <= out_count - 1;
    if (in_valid)
      begin
        if (count % N == N-1)
          out_count <= count+1;
      end
  end

always @(posedge clk)
  if (out_count != 0)
    out_valid <= 1;
  else
    out_valid <= 0;

always @(posedge clk)
  if (out_count != 0)
    if (out_count > DEPTH)
      data_out <= data[out_count - N - 1];
    else
      data_out <= data[out_count - 1];
  else
    data_out <= 0;
  
endmodule
