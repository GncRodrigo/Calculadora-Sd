`timescale 1ns/100ps

module tb_calc_top;

  // Inputs
  logic clock = 0;
  logic reset;
  logic [3:0] cmd;

  // Outputs
  logic [6:0] displays [7:0];
  logic [1:0] status;
  

  // Instância do DUT (Device Under Test)
  calc_top calc_top (
    .clock(clock),
    .reset(reset),
    .cmd(cmd),
    .displays(displays),
    .status(status)
  );

  // Geração de clock
  always #1 clock = ~clock;

  initial begin

  reset = 1; #2;
  reset = 0; #20;

  cmd = 4'd1; #30;
  cmd = 4'd2; #30;
  cmd = 4'b1010; #30;
  cmd = 4'd3; #30;
  cmd = 4'b1110; #30;

  $finish;

  end


endmodule