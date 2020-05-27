`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2020 06:45:28 AM
// Design Name: 
// Module Name: stream_out_matrix_ping_pong
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


module stream_out_matrix_ping_pong
#(BITS = 8, R = 3, C = 3)
(
input clk,
input in_valid,
input [BITS-1:0] a[R][C],
output logic out_valid = 0,
output logic [BITS-1:0] c = 0
);

localparam ELEMENTS = R * C;

logic [$clog2(ELEMENTS)-1:0] count = 0;
logic [BITS-1:0] a_temp[R][C]  = '{ default : 0 };

always @(posedge clk)
  if (in_valid)
    count <= ELEMENTS-1;
  else
    if (count > 0)
      count <= count - 1;
    else
      count <= count;

always @(posedge clk)
    if (in_valid)
      a_temp <= a;
    else
      a_temp <= a_temp;

always @(posedge clk)
  begin
    out_valid <= 0;
    if (in_valid)
      out_valid <= 1;
    if (count > 0)
      out_valid <= 1;
  end

always @(posedge clk)
  begin
    c <= 0;
    if (in_valid)
      c <= a[0][0];
    if (count > 0)
      c <= a_temp[(ELEMENTS - count) / C][(ELEMENTS - count) % C];
  end   

endmodule
