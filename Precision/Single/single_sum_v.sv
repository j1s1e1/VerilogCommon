`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2018 03:09:58 AM
// Design Name: 
// Module Name: single_sum_v
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


module single_sum_v
#(
parameter WIDTH = 10
)
(
input rstn,
input clk,
input in_valid,
input [31:0] vector_a[WIDTH],
output out_valid,
output [31:0] c
);

localparam LEVELS = $clog2(WIDTH);
localparam WIDTH_POW_2 = 2**LEVELS;
wire [31:0] vector_a_power2[WIDTH_POW_2];

genvar i, j;

generate
  begin
    for (i = 0; i < WIDTH; i = i + 1)
      assign vector_a_power2[i] = vector_a[i];
    for (i = WIDTH; i < WIDTH_POW_2; i = i + 1)
       assign vector_a_power2[i] = 32'b0;
  end
endgenerate

wire [31:0] sum_partial[WIDTH_POW_2*2 - 1];

assign sum_partial[0:WIDTH_POW_2-1] = vector_a_power2;
assign c = sum_partial[WIDTH_POW_2*2 - 2];

function integer calculate_source_start(integer i);
    automatic integer level_size = WIDTH_POW_2;
    automatic integer count = i;
    begin
      calculate_source_start =0;
      while (count > 0)
        begin
          calculate_source_start = calculate_source_start + level_size;
          level_size = level_size / 2;
          count = count - 1;
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
          begin : max_functions  
              begin
                localparam source_index = source_start + 2 * j;
                localparam result_index = result_start + j;
                single_add single_add_array(
                  .rstn(rstn),
                  .clk(clk),
                  .in_valid(1'b1),
                  .a(sum_partial[source_index]),
                  .b(sum_partial[source_index+1]),
                  .out_valid(),
                  .c(sum_partial[result_index])
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
