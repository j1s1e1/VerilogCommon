function [31:0] SingleFromHalf;
  input [15:0] half;
  reg sign;
  reg [7:0] exponent;
  reg [22:0] mantissa;
  begin
    sign = half[15];
    exponent = 8'd127 + {3'b0,half[14:10]} - 8'd15;
    mantissa = {half[9:0],13'b0};
    SingleFromHalf = (half[14:0] == 0) ?  
                        32'b0 :
                        {sign,exponent,mantissa};
  end                    
endfunction

function [15:0] RealToHalf;
  input real  a_real;
  reg [31:0] a_single;
  reg [4:0] a_exp;
  begin
    a_single = $shortrealtobits(a_real);
    if (a_single[30:23] < (127 - 15))
      RealToHalf = 16'b0;
    else
      begin
        if (a_single[30:23] > (127 + 16))
          RealToHalf = {a_single[31],15'b111_1111_1111_1111};
        else
          begin
            a_exp = a_single[30:23] - 127 + 15;
            RealToHalf = (a_single==0) ? 0 : {a_single[31],a_exp,a_single[22:13]};
          end
      end
  end
endfunction

function real RealFromHalf;
  input [15:0] half;
  reg [31:0] single;
  single = SingleFromHalf(half);
  RealFromHalf = $bitstoshortreal(single);
endfunction
