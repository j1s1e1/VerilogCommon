`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/13/2020 11:55:53 PM
// Design Name: 
// Module Name: interleave_block_input
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


module interleave_block_input
#(BITS = 8, IIR = 3, N = 10)
(
input clk,
input in_valid,
input [BITS-1:0] data_in,
output logic out_valid,
output logic block_start,
output logic [BITS-1:0] data_out
);

logic [BITS-1:0] data[IIR][N] = '{ default : 0 };
logic [$clog2(N)-1:0] input_count[IIR] = '{ default : 0 };
logic [$clog2(IIR)-1:0] set_count = 0;
logic [$clog2(IIR)-1:0] output_set_count = 0;
logic [$clog2(N):0] output_count[IIR] = '{ default : N };

always @(posedge clk)
  begin
    input_count <= input_count;
    if (in_valid)
      if (input_count[set_count] < N-1)
        input_count[set_count] <= input_count[set_count] + 1;
      else
        input_count[set_count] <= 0;
  end 

always @(posedge clk)
  begin
    set_count <= set_count;
    if (input_count[set_count] == N-1)
      if (set_count < IIR-1)
        set_count <= set_count + 1;
      else
        set_count <= 0;
  end
  
always @(posedge clk)
  begin
    data <= data;
    if (in_valid)
      data[set_count][input_count[set_count]] <= data_in;
  end

always @(posedge clk)
  if (output_set_count < IIR - 1)
    output_set_count <= output_set_count + 1;
  else
    output_set_count <= 0;
  
always @(posedge clk)
  begin
    output_count <= output_count;
    if (in_valid)
      begin
        if (input_count[set_count] == 0)
          output_count[set_count] <= 0;
      end
    if (output_count[output_set_count] < N)
      output_count[output_set_count] <= output_count[output_set_count] + 1;
  end

always @(posedge clk)
  begin
    data_out <= 0;
    if (output_count[output_set_count] < N)
      data_out <= data[output_set_count][output_count[output_set_count]];
  end

always @(posedge clk)
  begin
    block_start <= 0;
    if (output_count[output_set_count] == 0)
      block_start <= 1;
  end
  
always @(posedge clk)
  begin
    out_valid <= 0;
    if (output_count[output_set_count] < N)
      out_valid <= 1;
  end
  
endmodule
