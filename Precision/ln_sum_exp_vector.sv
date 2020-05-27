`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/03/2020 05:40:38 PM
// Design Name: 
// Module Name: ln_sum_exp_vector
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


module ln_sum_exp_vector
#(BITS = 16, PRECISION = "HALF", N=3, TABLES = 0)
(
input clk,
input in_valid,
input [BITS-1:0] a[N],
output out_valid,
output [BITS-1:0] c
);

localparam LEVELS = $clog2(N);
localparam N_POW_2 = 2**LEVELS;
logic in_valid_level[LEVELS];
logic out_valid_level[LEVELS];
logic [31:0] vector_a_power2[N_POW_2];
logic [31:0] ln_of_min;

assign in_valid_level[0] = in_valid;
for (genvar g = 1; g < LEVELS; g++)
  assign in_valid_level[g] = out_valid_level[g-1];
assign out_valid = out_valid_level[LEVELS-1];

genvar i, j;

generate
  begin
    for (i = 0; i < N; i++)
      assign vector_a_power2[i] = a[i];
    for (i = N; i < N_POW_2; i++)
       assign vector_a_power2[i] = ln_of_min;
  end
endgenerate

logic [31:0] ln_sum_exp_partial[N_POW_2*2 - 1];

assign ln_sum_exp_partial[0:N_POW_2-1] = vector_a_power2;
assign c = ln_sum_exp_partial[N_POW_2*2 - 2];

function integer calculate_source_start(integer i);
    automatic integer level_size = N_POW_2;
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
        localparam partials = N_POW_2 / 2**(i+1);
        localparam source_start = calculate_source_start(i);         // 0  16 24 28 ...
        localparam result_start = calculate_source_start(i+1);       // 16 24 28 ...
        ln_sum_exp #(.BITS(BITS), .PRECISION(PRECISION), .TABLES(TABLES)) ln_sum_exp_array0
        (
          .clk(clk),
          .in_valid(in_valid_level[i]),
          .a(ln_sum_exp_partial[source_start]),
          .b(ln_sum_exp_partial[source_start+1]),
          .out_valid(out_valid_level[i]),
          .c(ln_sum_exp_partial[result_start])
        );
        for (j = 1; j < partials; j = j + 1)
          begin : ln_sum_exp_functions  
              begin
                localparam source_index = source_start + 2 * j;
                localparam result_index = result_start + j;
                ln_sum_exp #(.BITS(BITS), .PRECISION(PRECISION), .TABLES(TABLES)) ln_sum_exp_array
                (
                  .clk(clk),
                  .in_valid(in_valid_level[i]),
                  .a(ln_sum_exp_partial[source_index]),
                  .b(ln_sum_exp_partial[source_index+1]),
                  .out_valid(),
                  .c(ln_sum_exp_partial[result_index])
                );
              end
           end
      end
endgenerate

set_value
#(.BITS(BITS), .PRECISION(PRECISION), .VALUE("LN_OF_MIN"))
set_value_min_value
(
.value(ln_of_min)
);     

endmodule
