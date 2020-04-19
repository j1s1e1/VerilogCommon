`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/20/2018 11:42:36 PM
// Design Name: 
// Module Name: delay
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


module delay
#(parameter DELAY = 1, WIDTH = 1)
(
input rstn,
input clk,
input [WIDTH-1:0] a,
output [WIDTH-1:0] c
);

if (DELAY == 0)
  assign c = a;
else
begin

reg [WIDTH-1:0] a_delay[DELAY] = '{ default : 0 };

assign c = a_delay[DELAY-1];

always @(posedge clk)
  if (!rstn)
    for (int i = 0; i < DELAY; i = i + 1)
      a_delay[i] <= 0;
  else
    begin
      a_delay[0] <= a;
      for (int i = 1; i < DELAY; i = i + 1)
        a_delay[i] <= a_delay[i-1];
    end
    
end

endmodule
