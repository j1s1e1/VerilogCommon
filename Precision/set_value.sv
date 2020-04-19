`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/13/2019 06:00:52 PM
// Design Name: 
// Module Name: set_value
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


module set_value
#(parameter BITS = 16, PRECISION = "HALF", VALUE = "PLUS_ONE")
(
output [BITS-1:0] value
);

if (PRECISION == "HALF")
  begin
    if (VALUE == "PLUS_ONE")
      assign value = 16'h3C00;
    if (VALUE == "MINUS_ONE")
      assign value = 16'hBC00; 
    if (VALUE == "PLUS_HALF")
      assign value = 16'h3800;       
    if (VALUE == "MINUS_HALF")
      assign value = 16'hB800;
    if (VALUE == "PLUS_TWO")
      assign value = 16'h4000;
    if (VALUE == "MINUS_TWO")
      assign value = 16'hC000;     
    if (VALUE == "MAX")
      assign value = 16'h7C00;        
  end
  
if(PRECISION[23:16] == "_")  // Fixed format is FIXED_XX_XX
  begin
    localparam FRACTION = 10 * (PRECISION[15:8] - 8'h30) + PRECISION[7:0] - 8'h30;
    if (VALUE == "PLUS_ONE")
      assign value = 1 << FRACTION;
    if (VALUE == "MINUS_ONE")
      assign value = ~(1 << FRACTION) + 1'b1; 
    if (VALUE == "PLUS_HALF")
      assign value = 1 << (FRACTION - 1);       
    if (VALUE == "MINUS_HALF")
      assign value = ~(1 << (FRACTION - 1)) + 1'b1; 
    if (VALUE == "PLUS_TWO")
      assign value = 1 << (FRACTION + 1);       
    if (VALUE == "MINUS_TWO")
      assign value = ~(1 << (FRACTION + 1)) + 1'b1; 
  end  

if (PRECISION == "SINGLE")
  begin
    if (VALUE == "PLUS_ONE")
      assign value = 32'h3F800000;
    if (VALUE == "MINUS_ONE")
      assign value = 32'hBF800000; 
    if (VALUE == "PLUS_HALF")
      assign value = 32'h3F000000;       
    if (VALUE == "MINUS_HALF")
      assign value = 32'hBF000000; 
    if (VALUE == "PLUS_TWO")
      assign value = 32'h40000000;       
    if (VALUE == "MINUS_TWO")
      assign value = 32'hC0000000;    
    if (VALUE == "MAX")
      assign value = 32'h7F800000;          
  end  
  
// Constants needed for Pade Approximation for Exp()
  
if (PRECISION == "HALF")
  begin
    if (VALUE == "LOG2_E")
      assign value = 16'hXXXX;  // 1.44269504088896
    if (VALUE == "FM_EXP2_Q0")
      assign value = 16'h5b49;  // $shortrealtobits(2.33184211722314911771e2);
    if (VALUE == "FM_EXP2_Q1")
      assign value = 16'h6c44; // $shortrealtobits(4.36821166879210612817e3);
    if (VALUE == "FM_EXP2_P0")
      assign value = 16'h25e9; // $shortrealtobits(2.30933477057345225087e-2);       
    if (VALUE == "FM_EXP2_P1")
      assign value = 16'h4d0c; // $shortrealtobits(2.02020656693165307700e1);
    if (VALUE == "FM_EXP2_P2")
      assign value = 16'h65e9; // $shortrealtobits(1.51390680115615096133e3);             
  end

if (PRECISION == "SINGLE")
  begin
    if (VALUE == "LOG2_E")
      assign value = 32'h3fb8aa3b;  // 1.44269504088896  
    if (VALUE == "FM_EXP2_Q0")
      assign value = 32'h43692f28;  // $shortrealtobits(2.33184211722314911771e2);
    if (VALUE == "FM_EXP2_Q1")
      assign value = 32'h458881b1; // $shortrealtobits(4.36821166879210612817e3);
    if (VALUE == "FM_EXP2_P0")
      assign value = 32'h3cbd2e43; // $shortrealtobits(2.30933477057345225087e-2);       
    if (VALUE == "FM_EXP2_P1")
      assign value = 32'h41a19dd5; // $shortrealtobits(2.02020656693165307700e1);
    if (VALUE == "FM_EXP2_P2")
      assign value = 32'h44bd3d05; // $shortrealtobits(1.51390680115615096133e3);            
  end    
  
if(PRECISION[23:16] == "_")  // Fixed format is FIXED_XX_XX
  begin
    localparam FRACTION = 10 * (PRECISION[15:8] - 8'h30) + PRECISION[7:0] - 8'h30;
    if (VALUE == "LOG2_E")
      assign value = 'h17154 >> (16-FRACTION);  // 1.44269504088896
    if (VALUE == "FM_EXP2_Q0")
      assign value = 'hE92F28 >> (16-FRACTION);  // $shortrealtobits(2.33184211722314911771e2);
    if (VALUE == "FM_EXP2_Q1")
      assign value = 'h1110362F >> (16-FRACTION); // $shortrealtobits(4.36821166879210612817e3);
    if (VALUE == "FM_EXP2_P0")
      assign value = 'h5E9 >> (16-FRACTION); // $shortrealtobits(2.30933477057345225087e-2);       
    if (VALUE == "FM_EXP2_P1")
      assign value = 'h1433BA >> (16-FRACTION); // $shortrealtobits(2.02020656693165307700e1);
    if (VALUE == "FM_EXP2_P2")
      assign value = 'h5E9E824 >> (16-FRACTION); // $shortrealtobits(1.51390680115615096133e3);
  end       
     
endmodule
