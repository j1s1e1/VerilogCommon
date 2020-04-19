module min_index_matrix_row
#(parameter BITS = 16, PRECISION = "HALF", INDEX_BITS = 4, N = 3, M = 2)
(
input rstn,
input clk,
input in_valid,
input [BITS-1:0] a[N][M],
output out_valid,
output [INDEX_BITS-1:0] index[N],
output [BITS-1:0] c[N]
);

logic out_valid_array[N];

assign out_valid = out_valid_array[0];

for (genvar g = 0; g < N; g++)
  min_index_vector
  #(.BITS(BITS), .PRECISION(PRECISION), .INDEX_BITS(INDEX_BITS), .N(M))
  min_index_vector_array
  (
    .rstn,
    .clk,
    .in_valid,
    .vector_a(a[g]),
    .out_valid(out_valid_array[g]),
    .index(index[g]),
    .c(c[g])
);

endmodule
