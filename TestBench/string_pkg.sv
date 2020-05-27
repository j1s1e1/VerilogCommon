`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/28/2020 06:27:14 PM
// Design Name: 
// Module Name: string_pkg
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


package string_pkg;

function void StringToBits(string str, output logic bits[]);
  int length;
  length = str.len();
  bits = new[length*8];
  for(int i=0; i < length; i++)
    for (int j = 0; j < 8; j++)
      bits[8*i+j] = str[i][7-j];
endfunction

function void BitsToReals(logic bits[], output real data[]);
  int length;
  length = bits.size();
  data = new[length];
  for(int i=0; i < length; i++)
    data[i] = bits[i] ? 1.0 : -1.0;
endfunction

function void MatrixBitsToReals(logic bits[][], output real data[][]);
  int length;
  length = bits.size();
  data = new[length];
  for(int i=0; i < length; i++)
    BitsToReals(bits[i], data[i]);
endfunction

function void StringToReals(string str, output real data[]);
  int length;
  length = str.len();
  data = new[length*8];
  for(int i=0; i < length; i++)
    for (int j = 0; j < 8; j++)
      data[8*i+j] = str[i][7-j] ? 1.0 : -1.0;
endfunction

endpackage
