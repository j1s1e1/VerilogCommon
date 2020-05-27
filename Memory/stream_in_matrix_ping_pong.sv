`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2020 06:26:24 AM
// Design Name: 
// Module Name: stream_in_matrix_ping_pong
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


module stream_in_matrix_ping_pong
#(BITS = 8, R = 3, C = 3)
(
input clk,
input in_valid,
input [BITS-1:0] a,
output logic out_valid = 0,
output logic [BITS-1:0] c[R][C] = '{ default : 0 }
);

localparam ELEMENTS = R * C;

logic [$clog2(ELEMENTS)-1:0] count = 0;
logic [BITS-1:0] c_temp[ELEMENTS]  = '{ default : 0 };

always @(posedge clk)
  if (in_valid)
    if (count < ELEMENTS-1)
      count <= count + 1;
    else
      count <= 0;
  else
    count <= count;

always @(posedge clk)
    if (in_valid)
      begin
        c_temp[ELEMENTS-1] <= a;
        for (int i = 0; i < ELEMENTS-1; i++)
          c_temp[i] <= c_temp[i+1];
      end
    else
      c_temp <= c_temp;

always @(posedge clk)
  begin
    out_valid <= 0;
    if (in_valid)
      if (count == ELEMENTS-1)
        out_valid <= 1;
  end

always @(posedge clk)
  begin
    c <= c;
    if (in_valid)
      if (count == ELEMENTS-1)
        begin
          c[R-1][C-1] <= a;
          for (int j = 0; j < C-1; j++)
            c[R-1][j] <= c_temp[ELEMENTS - C + j + 1];
          for (int i = 0; i < R-1; i++)
            for (int j = 0; j < C; j++)
              c[i][j] <= c_temp[C * i + j + 1];
      end
  end   

endmodule
