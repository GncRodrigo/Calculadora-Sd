`timescale 1ns/100ps

module tb_calc_top;

  // ins
  logic clock = 0;
  logic reset;
  logic [3:0] cmd;
  
  // outs
  logic [6:0] displays [7:0];
  logic [1:0] status;
  logic [26:0] digits;
  
  calc_top calc_top (
    .clock(clock),
    .reset(reset),
    .cmd(cmd),
    .displays(displays),
    .status(status),
    .digits(digits)
    );

  always #1 clock = ~clock; 

  initial begin
    reset = 1; #4;
    reset = 0; #4; 

    // 0
    cmd = 4'b0001; #2;
   // é só pra mostrar o 1 indo
    // '+'
   

  

    // '='
    

  end  


endmodule
