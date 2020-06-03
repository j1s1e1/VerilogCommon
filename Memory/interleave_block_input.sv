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
output logic out_valid = 0,
output logic block_start = 0,
output logic [BITS-1:0] data_out = 0
);

logic start = 0;
logic [IIR-1:0] active;
logic [BITS-1:0] data[IIR][N] = '{ default : 0 };
logic [$clog2(N)-1:0] input_count[IIR] = '{ default : 0 };
logic [$clog2(IIR)-1:0] set_count = 0;
logic [$clog2(IIR)-1:0] output_set_count = 0;
logic [$clog2(N):0] output_count[IIR] = '{ default : N };

for (genvar g = 0; g < IIR; g++)
  assign active[g] = (output_count[g] == N) ? 0 : 1;

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

// This ensures that multiple modules with 
// blocks offset by a number of clock cycles 
// will generate data with equal delay
always @(posedge clk)
  begin
    start <= start;
    if (in_valid)
      start <= 1;
  end
  
always @(posedge clk)
  begin
    if (active != 0)
      if (output_set_count < IIR - 1)
        output_set_count <= output_set_count + 1;
      else
        output_set_count <= 0;
    else
      output_set_count <= set_count;
  end
  
always @(posedge clk)
  begin
    output_count <= output_count;
    if (output_count[output_set_count] < N)
      output_count[output_set_count] <= output_count[output_set_count] + 1;
    if (in_valid)
      begin
        if (input_count[set_count] == 0)
          output_count[set_count] <= 0;
      end
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
