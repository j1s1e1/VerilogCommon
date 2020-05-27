`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/20/2018 12:35:25 AM
// Design Name: 
// Module Name: integer_divide
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
//  4180 LUT
// 
//////////////////////////////////////////////////////////////////////////////////


module integer_divide
#(
parameter WIDTH = 32
)
(
input rstn,
input clk,
input in_valid,
input [WIDTH-1:0] dividend,
input [WIDTH-1:0] divisor,
output out_valid,
output reg [WIDTH-1:0] quotient = 0,
output reg [WIDTH-1:0] remainder = 0
);

reg [2*WIDTH-1:0] dividend_copy[WIDTH+1] = '{ default : 0 };
reg [2*WIDTH-1:0] divisor_copy[WIDTH+1] = '{ default : {WIDTH*2{1'b1}} };
reg [WIDTH-1:0] result[WIDTH+1] = '{ default : 0 };

integer i;

always @(posedge clk)
  if (!rstn)
    for (i = 0; i < WIDTH+1; i = i + 1)
      begin
        dividend_copy[i] <= 0;
        divisor_copy[i] <= {WIDTH*2{1'b1}};
        result[i] <= 0;
      end
  else
    begin
      if (divisor != 0)
        begin
          dividend_copy[0] <= {{WIDTH{1'b0}},dividend};
          divisor_copy[0] <= {1'b0,divisor,{{WIDTH-1{1'b0}}}};
          result[0] <= 0;
        end
      else
        begin
          dividend_copy[0] <= 0;
          divisor_copy[0] <= {WIDTH*2{1'b1}};
          result[0] <= 0;
        end
      for (int i = 1; i < WIDTH+1; i = i + 1)
        begin
          if (dividend_copy[i-1] >= divisor_copy[i-1])
            begin
              dividend_copy[i] <= dividend_copy[i-1] - divisor_copy[i-1];
              result[i] <= result[i-1] | 1 << (WIDTH-i);
            end
          else
            begin
              dividend_copy[i] <= dividend_copy[i-1];
              result[i] <= result[i-1];
            end
          divisor_copy[i] <= {1'b0,divisor_copy[i-1][2*WIDTH-1:1]};
        end
    end

always @(posedge clk)
  if (!rstn)
    quotient <= 0;
  else
    quotient <= result[WIDTH];
    
 always @(posedge clk)
   if (!rstn)
     remainder <= 0;
   else
     remainder <= dividend_copy[WIDTH];  
     
delay #(.DELAY(WIDTH+2), .WIDTH(1))
     delay_outv
     (
     .rstn(rstn),
     .clk(clk),
     .a(in_valid),
     .c(out_valid)
     );      

endmodule
