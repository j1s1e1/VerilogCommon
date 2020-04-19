`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/12/2019 07:53:43 PM
// Design Name: 
// Module Name: sum_vector
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


module sum_vector
#(parameter BITS = 16, PRECISION = "HALF", N = 3)
(
input clk,
input in_valid,
input [BITS-1:0] vin[N],
output out_valid,
output [BITS-1:0] sum
);

if (N == 1)
  begin
    assign out_valid = in_valid;
    assign sum = vin[0];
  end
else
  begin
      if (PRECISION == "HALF")
        half_sum_v #(.WIDTH(N))
        half_sum_v_1
        (
          .rstn(1'b1),
          .clk,
          .in_valid,
          .vector_a(vin),
          .out_valid,
          .c(sum)
        );
      if (PRECISION == "SINGLE")
        single_sum_v #(.WIDTH(N))
        single_sum_v_1
        (
          .rstn(1'b1),
          .clk,
          .in_valid,
          .vector_a(vin),
          .out_valid,
          .c(sum)
        );        
  end

endmodule
