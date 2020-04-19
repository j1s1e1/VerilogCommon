`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/12/2019 09:35:06 PM
// Design Name: 
// Module Name: half_max_abs_v
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


module half_max_abs_v
#(
parameter WIDTH = 16
)
(
input rstn,
input clk,
input in_valid,
input [15:0] vector_a[WIDTH],
output out_valid,
output [$clog2(WIDTH)-1:0] index,
output [15:0] c
);

localparam LEVELS = $clog2(WIDTH);
localparam WIDTH_POW_2 = 2**LEVELS;

if (WIDTH > 2)
  begin
    logic out_valid_array[2];
    logic [$clog2(WIDTH_POW_2/2)-1:0] index_array[2];
    logic [15:0] c_array[2];
    half_max_abs_v #(.WIDTH(WIDTH_POW_2/2))
    half_max_abs_v_1
    (
      .rstn,
      .clk,
      .in_valid(in_valid),
      .vector_a(vector_a[0:WIDTH_POW_2/2-1]),
      .out_valid(out_valid_array[0]),
      .index(index_array[0]),
      .c(c_array[0])
    );
    
    half_max_abs_v #(.WIDTH(WIDTH - WIDTH_POW_2/2))
    half_max_abs_v_2
    (
      .rstn,
      .clk,
      .in_valid(in_valid),
      .vector_a(vector_a[WIDTH_POW_2/2:WIDTH-1]),
      .out_valid(out_valid_array[1]),
      .index(index_array[1]),
      .c(c_array[1])
    );
    assign out_valid = out_valid_array[0];
    assign index = (c_array[1] > c_array[0]) ? WIDTH_POW_2/2 + index_array[1] : index_array[0];
    assign c = (c_array[1] > c_array[0]) ? c_array[1] : c_array[0];
  end
else
  if (WIDTH == 2)
    begin
      half_max_abs
      half_max_abs1
      (
        .rstn,
        .clk,
        .in_valid,
        .a(vector_a[0][14:0]),
        .b(vector_a[1][14:0]),
        .out_valid,
        .b_max(index),
        .c(c[14:0])
      );
      assign c[15] = 0;
    end
  else
    begin
      assign out_valid = in_valid;
      assign index = 0;
      assign c[14:0] = vector_a[0][14:0];
      assign c[15] = 0;
    end

endmodule
