`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/27/2019 06:48:18 PM
// Design Name: 
// Module Name: altsyncram
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


module altsyncram
#(intended_device_family = "", operation_mode = "", width_a = 8, widthad_a=8, numwords_a=8,
 width_b = 8, widthad_b=8, numwords_b=8, lpm_type = "", width_byteena_a = 1, outdata_reg_b = "",
 indata_aclr_a = "", wrcontrol_aclr_a = "", address_aclr_a = "", address_reg_b = "",
 address_aclr_b = "", outdata_aclr_b = "", read_during_write_mode_mixed_ports = "", ram_block_type = "")
(
input wren_a,
input clock0,
input [widthad_a-1:0] address_a,
input [widthad_b-1:0] address_b,
input rden_b,
input [width_a-1:0] data_a,
output reg [width_b:0] q_b,
input aclr0,  // zeroed, not used
input aclr1,  // zeroed, not used
input addressstall_a,  // zeroed, not used
input addressstall_b,  // zeroed, not used
input byteena_a, // forced to one, not used
input byteena_b, // forced to one, not used
input clock1, // forced to one, not used
input clocken0, // forced to one, not used
input clocken1, // forced to one, not used
input [width_b-1:0] data_b, // forced to 64 ones, not used
output [widthad_a-1:0] q_a, // not connected
input wren_b // zeroed, not used
);

logic [width_a-1:0] mem[numwords_a];

always @(posedge clock0)
  begin
    if (wren_a)
      mem[address_a] <= data_a;
  end
  
always @(posedge clock0)
  begin
    q_b <= q_b;
    if (rden_b)
      q_b <= mem[address_b];
  end

endmodule
