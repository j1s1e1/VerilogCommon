`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2018 03:01:23 PM
// Design Name: 
// Module Name: min_vector
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


module min_vector
#(parameter BITS = 16, PRECISION = "HALF", WIDTH = 3)
(
input rstn,
input clk,
input in_valid,
input [BITS-1:0] vector_a[WIDTH],
output out_valid,
output [BITS-1:0] c
);

localparam LEVELS = $clog2(WIDTH);
localparam WIDTH_POW_2 = 2**LEVELS;
wire [BITS-1:0] vector_a_power2[WIDTH_POW_2];

genvar i, j;

generate
  begin
    for (i = 0; i < WIDTH; i = i + 1)
      assign vector_a_power2[i] = vector_a[i];
    for (i = WIDTH; i < WIDTH_POW_2; i = i + 1)
       assign vector_a_power2[i] = vector_a[WIDTH-1];
  end
endgenerate

wire [BITS-1:0] min_partial[WIDTH_POW_2*2 - 1];

assign min_partial[0:WIDTH_POW_2-1] = vector_a_power2;
assign c = min_partial[WIDTH_POW_2*2 - 2];

function integer calculate_source_start(integer i);
    automatic integer level_size = WIDTH_POW_2;
    begin
      calculate_source_start =0;
      while (i > 0)
        begin
          calculate_source_start = calculate_source_start + level_size;
          level_size = level_size / 2;
          i = i - 1;
        end
    end
  endfunction

generate
  integer results = 8;
  integer source_index = 0;
    for (i = 0; i < LEVELS; i = i + 1)
      begin : levels
        localparam partials = WIDTH_POW_2 / 2**(i+1);
        localparam source_start = calculate_source_start(i);         // 0  16 24 28 ...
        localparam result_start = calculate_source_start(i+1);       // 16 24 28 ...
        for (j = 0; j < partials; j = j + 1)
          begin : min_functions  
              begin
                localparam source_index = source_start + 2 * j;
                localparam result_index = result_start + j;
                min
                #(.BITS(BITS), .PRECISION(PRECISION))
                min_array
                (
                  .rstn(rstn),
                  .clk(clk),
                  .in_valid,
                  .a(min_partial[source_index]),
                  .b(min_partial[source_index+1]),
                  .out_valid(),
                  .c(min_partial[result_index])
                );
              end
           end
      end
endgenerate

delay #(.DELAY(LEVELS), .WIDTH(1))
delay_valid
(
.rstn(rstn),
.clk(clk),
.a(in_valid),
.c(out_valid)
); 

endmodule