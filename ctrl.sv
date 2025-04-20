module ctrl(
  input logic clock,
  input logic reset,
  input logic[3:0] dig,
  input logic[3:0] pos,

  output [7:0]displays[6:0]; // 8 displays, cada um com 7 segmentos
);

  logic[8][3:0] data = 0;

// aqui amarra tds 8 displays num vetor, que vai ser amarrado la no top
  display d0 (.data(data[0]), .a(displays[0][1]), .b(displays[0][2]), .c(displays[0][3]), .d(displays[0][4]), .e(displays[0][5]), .f(displays[0][6]), .g(displays[0][7]), .dp());
  display d1 (.data(data[1]), .a(displays[1][1]), .b(displays[1][2]), .c(displays[1][3]), .d(displays[1][4]), .e(displays[1][5]), .f(displays[1][6]), .g(displays[1][7]), .dp());
  display d2 (.data(data[2]), .a(displays[2][1]), .b(displays[2][2]), .c(displays[2][3]), .d(displays[2][4]), .e(displays[2][5]), .f(displays[2][6]), .g(displays[2][7]), .dp());
  display d3 (.data(data[3]), .a(displays[3][1]), .b(displays[3][2]), .c(displays[3][3]), .d(displays[3][4]), .e(displays[3][5]), .f(displays[3][6]), .g(displays[3][7]), .dp());
  display d4 (.data(data[4]), .a(displays[4][1]), .b(displays[4][2]), .c(displays[4][3]), .d(displays[4][4]), .e(displays[4][5]), .f(displays[4][6]), .g(displays[4][7]), .dp());
  display d5 (.data(data[5]), .a(displays[5][1]), .b(displays[5][2]), .c(displays[5][3]), .d(displays[5][4]), .e(displays[5][5]), .f(displays[5][6]), .g(displays[5][7]), .dp());
  display d6 (.data(data[6]), .a(displays[6][1]), .b(displays[6][2]), .c(displays[6][3]), .d(displays[6][4]), .e(displays[6][5]), .f(displays[6][6]), .g(displays[6][7]), .dp());
  display d7 (.data(data[7]), .a(displays[7][1]), .b(displays[7][2]), .c(displays[7][3]), .d(displays[7][4]), .e(displays[7][5]), .f(displays[7][6]), .g(displays[7][7]), .dp());

  always @(posedge clock, negedge reset) begin

    if(reset == 1) begin
      data[0] = 0;
      data[1] = 0;
      data[2] = 0;
      data[3] = 0;
      data[4] = 0;
      data[5] = 0;
      data[6] = 0;
      data[7] = 0;
    end else begin
      if(pos < 8 && dig < 10) begin
        data[pos] = dig;
      end
    end

  end

endmodule