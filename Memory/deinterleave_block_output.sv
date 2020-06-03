`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/14/2020 01:09:24 AM
// Design Name: 
// Module Name: deinterleave_block_output
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


module deinterleave_block_output
#(BITS = 8, IIR = 3, N = 10)
(
input clk,
input in_valid,
input [BITS-1:0] data_in,
output logic out_valid = 0,
output logic [BITS-1:0] data_out = 0
);

// data arrives a1 b1 c1 a2 b2 c2 ...
// data output a1 a2 a3... b1 b2 b3 ... c1 c2 c3 ...
// enough storage for 2 x IIR blocks
// block data for each set can be offset, ie
// data arrives a5 b4 c1 a6 b5 c2 ...

logic [BITS-1:0] data[IIR][N] = '{ default : 0 };
logic [$clog2(N):0] input_count[IIR] = '{ default : 0 };
logic [$clog2(IIR)-1:0] set_count = 0;

logic [$clog2(N):0] output_count[IIR] = '{ default : 0 };

logic  [$clog2(IIR):0] next_output_set_index = 0;
logic  [$clog2(IIR):0] available_output_set_index = 0;
logic  [$clog2(IIR):0] next_output_set[IIR+1] = '{ default : IIR };

// Trigger count added to establish constant timing between 
// input to block interleave and output of deinterleave
// without this adjustment, when 2 blocks with an even 
// number of elements are intereleaved, a gap forms between the 
// first two blocks.
logic [$clog2(N):0] trigger_count;

assign trigger_count = (out_valid) ? N-2 : N-1;

always @(posedge clk)               // Rotates regardless of input
  if (set_count < IIR - 1)          // This means first set might not 
    set_count <= set_count + 1;     // go into first set
  else
    set_count <= 0;

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
    available_output_set_index <= available_output_set_index;
    if (in_valid)
      if (input_count[set_count] == trigger_count)
        if (available_output_set_index < IIR)
          available_output_set_index <= available_output_set_index + 1;
        else
          available_output_set_index <= 0;
  end

always @(posedge clk)
  begin
    next_output_set <= next_output_set;
    if (next_output_set[next_output_set_index] < IIR)
      if (output_count[next_output_set[next_output_set_index]] == N-1)
        next_output_set[next_output_set_index] <= IIR;
    if (in_valid)
      begin
        if (input_count[set_count] == trigger_count)
          next_output_set[available_output_set_index] <= set_count;
      end
  end
  
// Data can be input every cycle
// If blocks are streamed constantly, more storage may be needed since input
// is a1 b1 c1
// but all a1 to an are output before any b or c
always @(posedge clk)
  begin                      
    data <= data;
    if (in_valid)
      data[set_count][input_count[set_count]] <= data_in;
  end

always @(posedge clk)
  begin
    output_count <= output_count;
    if (next_output_set[next_output_set_index] < IIR)
      if (output_count[next_output_set[next_output_set_index]] < N - 1)
        output_count[next_output_set[next_output_set_index]] <= output_count[next_output_set[next_output_set_index]] + 1;
      else
        output_count[next_output_set[next_output_set_index]] <= 0;
  end

always @(posedge clk)
  begin
    next_output_set_index <= next_output_set_index;
    if (next_output_set[next_output_set_index] < IIR)
      if (output_count[next_output_set[next_output_set_index]] == N - 1)
        if (next_output_set_index < IIR)
          next_output_set_index <= next_output_set_index + 1;
        else
          next_output_set_index <= 0;
  end
    
always @(posedge clk)
  if (next_output_set[next_output_set_index] < IIR)
    data_out <= data[next_output_set[next_output_set_index]][output_count[next_output_set[next_output_set_index]]];
  else
    data_out <= 0;

always @(posedge clk)
  if (next_output_set[next_output_set_index] < IIR)
    out_valid <= 1;
  else
    out_valid <= 0;
    
endmodule
