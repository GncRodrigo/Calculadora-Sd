`timescale 1ns/100ps

module tb_ctrl;

  // ins
  logic clock = 0;
  logic reset;
  logic[3:0] dig;
  logic[3:0] pos;

  // outs
  logic[8] a;
  logic[8] b;
  logic[8] c;
  logic[8] d;
  logic[8] e;
  logic[8] f;
  logic[8] g;
  logic[8] dp;

  always #1 clock = ~clock; 

  ctrl master0(.*);

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
