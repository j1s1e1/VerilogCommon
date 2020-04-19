module min_index_vector
#(parameter BITS = 16, PRECISION = "HALF", INDEX_BITS = 4, N = 3)
(
input rstn,
input clk,
input in_valid,
input [BITS-1:0] vector_a[N],
output out_valid,
output [INDEX_BITS-1:0] index,
output [BITS-1:0] c
);

localparam LEVELS = $clog2(N);
localparam N_POW_2 = 2**LEVELS;

if (N > 2)
  begin
    logic out_valid_array[2];
    logic [INDEX_BITS-1:0] index_array0;
    logic [INDEX_BITS-1:0] index_array1;
    logic [BITS-1:0] c_array[2];
    min_index_vector #(.BITS(BITS), .INDEX_BITS(INDEX_BITS), .N(N_POW_2/2), .PRECISION(PRECISION))
    min_index_vector_1
    (
      .rstn,
      .clk,
      .in_valid(in_valid),
      .vector_a(vector_a[0:N_POW_2/2-1]),
      .out_valid(out_valid_array[0]),
      .index(index_array0),
      .c(c_array[0])
    );   
    
    min_index_vector #(.BITS(BITS), .INDEX_BITS(INDEX_BITS), .N(N - N_POW_2/2), .PRECISION(PRECISION))
    min_index_vector_2
    (
      .rstn,
      .clk,
      .in_valid(in_valid),
      .vector_a(vector_a[N_POW_2/2:N-1]),
      .out_valid(out_valid_array[1]),
      .index(index_array1),
      .c(c_array[1])
    );
    assign out_valid = out_valid_array[0];
    assign index = (c_array[1] < c_array[0]) ? N_POW_2/2 + index_array1 : index_array0;
    assign c = (c_array[1] < c_array[0]) ? c_array[1] : c_array[0];
  end
else
  begin
    if (INDEX_BITS > 1) assign index[INDEX_BITS-1:1] = 0;
    if (N == 2)
      begin      
        min #(.BITS(BITS), .PRECISION(PRECISION))
        min1
        (
          .rstn,
          .clk,
          .in_valid,
          .a(vector_a[0]),
          .b(vector_a[1]),
          .out_valid,
          .b_min(index[0]),
          .c(c)
        );
      end
    else
      begin
        delay #(.DELAY(1), .WIDTH(1))
        delay_out_valid
        (
          .rstn(1'b1),
          .clk(clk),
          .a(in_valid),
          .c(out_valid)
        ); 
        delay #(.DELAY(1), .WIDTH(1))
        delay_index
        (
          .rstn(1'b1),
          .clk(clk),
          .a(1'b0),
          .c(index)
        );      
        delay #(.DELAY(1), .WIDTH(BITS))
        delay_c
        (
          .rstn(1'b1),
          .clk(clk),
          .a(vector_a[0]),
          .c(c)
        );          
      end
  end  
endmodule
