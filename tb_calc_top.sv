`timescale 1ns/100ps

module tb_calc_top;

  // ins
  logic clock = 0;
  logic reset;
  logic [3:0] cmd;
  

  // outs
  logic [6:0] displays [7:0];
  logic [1:0] status;
  
  calc_top calc_top (
    .clock(clock),
    .reset(reset),
    .cmd(cmd),
    .displays(displays),
    .status(status)
    );

  always #1 clock = ~clock; 

  initial begin
    reset = 1; #4
    reset = 0; #4 

    // 0

    cmd = 4'd1; #2; 
    cmd = 4'd2; #2; 
    cmd = 4'd3; #2; 
    cmd = 4'd4; #2; 
   
    // '+'
    cmd = 4'b1010; #2; // -6 em decimal

    cmd = 4'd1; #2; 
    cmd = 4'd2; #2; 
    cmd = 4'd3; #2; 
    cmd = 4'd4; #2; 

    // '='
    cmd = 4'b1110; #2; // -2 em decimal
    cmd = 4'd0; // zera cmd, ś (descobri que dá pra colocar acento no s, que pica), fica "mais bonito"

  end  


endmodule
