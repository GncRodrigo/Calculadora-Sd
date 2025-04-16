`timescale 1ns/100ps

module tb_calc;

  // ins
  logic clock = 0;
  logic reset;
  logic[3:0] cmd;

  // outs


  always #1 clock = ~clock; 

  calc calculator();

  initial begin
    dig = 0;
    pos = 0;
    reset = 1; #2 reset = 0;
  end  

  always @(posedge clock) begin
    dig <= dig + 1;

    if(dig == 4'b1111) begin
      pos = pos +1;
    end
  end

endmodule
