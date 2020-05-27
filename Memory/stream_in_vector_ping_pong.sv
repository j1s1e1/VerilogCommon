`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2020 06:03:28 AM
// Design Name: 
// Module Name: stream_in_vector_ping_pong
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
// Elements stream in one at a time on in_valid
// Once N elements have been streamed in, out valid toggles
// Output values are held until next full set of elements have been streamed in
//
//////////////////////////////////////////////////////////////////////////////////


module stream_in_vector_ping_pong
#(BITS = 8, N = 3)
(
input clk,
input in_valid,
input [BITS-1:0] a,
output logic out_valid = 0,
output logic [BITS-1:0] c[N] = '{ default : 0 }
);

logic [$clog2(N)-1:0] count = 0;
logic [BITS-1:0] c_temp[N]  = '{ default : 0 };

always @(posedge clk)
  if (in_valid)
    if (count < N-1)
      count <= count + 1;
    else
      count <= 0;
  else
    count <= count;

always @(posedge clk)
    if (in_valid)
      begin
        c_temp[N-1] <= a;
        for (int i = 0; i < N-1; i++)
          c_temp[i] <= c_temp[i+1];
      end
    else
      c_temp <= c_temp;

always @(posedge clk)
  begin
    out_valid <= 0;
    if (in_valid)
      if (count == N-1)
        out_valid <= 1;
  end

always @(posedge clk)
  begin
    c <= c;
    if (in_valid)
      if (count == N-1)
        begin
          c[N-1] <= a;
          for (int i = 0; i < N-1; i++)
            c[i] <= c_temp[i+1];
      end
  end   

endmodule
