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
  always #2 clock = ~clock;

  initial begin

  reset = 1; #2;
  reset = 0; #25;

  if (status == 2'b01)begin cmd = 4'd1;    end  #50;
  if (status == 2'b01)begin cmd = 4'd2;    end  #50;
  if (status == 2'b01)begin cmd = 4'b1010; end  #50;
  if (status == 2'b01)begin cmd = 4'd3;   end   #50;
  if (status == 2'b01)begin cmd = 4'b1110; end  #50;

  $finish;

  end


endmodule