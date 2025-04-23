`timescale 1ns/100ps

module tb_calc_top;

  // Inputs
  logic clock = 0;
  logic reset;
  logic [3:0] cmd;

  // Outputs
  logic [6:0] displays [7:0];
  logic [1:0] status;
  logic [26:0] digits;

  // Instância do DUT (Device Under Test)
  calc_top calc_top (
    .clock(clock),
    .reset(reset),
    .cmd(cmd),
    .displays(displays),
    .status(status),
    .digits(digits)
  );

  // Geração de clock
  always #1 clock = ~clock;

  initial begin

  reset = 1; #4;
  reset = 0; #4;

  cmd = 4'd1; #20;
  cmd = 4'b1010; #15; cmd = 4'd0;
  cmd = 4'd2; #20;
  cmd = 4'b1110; #20;

  end

endmodule