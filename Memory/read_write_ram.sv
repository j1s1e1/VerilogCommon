`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/06/2020 09:16:11 PM
// Design Name: 
// Module Name: read_write_ram
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


module read_write_ram
#(parameter BITS = 8, N=1024)
(
input clk,
input we,
input [$clog2(N)-1:0] write_addr,
input [BITS-1:0] write_data,
input [$clog2(N)-1:0] read_addr,
output logic [BITS-1:0] read_data
);

logic [BITS-1:0] data[N];

always @(posedge clk)
  begin
    //data <= data;
    if (we)
      data[write_addr] <= write_data;
    read_data <= data[read_addr];
  end

endmodule
