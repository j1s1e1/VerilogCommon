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


module dual_port_ram
#(parameter BITS = 8, N=1024)
(
input clk,
input we1,
input [$clog2(N)-1:0] write_addr1,
input [BITS-1:0] write_data1,
input [$clog2(N)-1:0] read_addr1,
input we2,
input [$clog2(N)-1:0] write_addr2,
input [BITS-1:0] write_data2,
input [$clog2(N)-1:0] read_addr2,
output logic [BITS-1:0] read_data1,
output logic [BITS-1:0] read_data2
);

logic [BITS-1:0] data[N];

always @(posedge clk)
  begin
    //data <= data;
    if (we1)
      data[write_addr1] <= write_data1;
    if (we2)
      data[write_addr2] <= write_data2;
    read_data1 <= data[read_addr1];
    read_data2 <= data[read_addr2];
  end

endmodule
