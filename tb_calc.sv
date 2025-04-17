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
    
  end  


endmodule
