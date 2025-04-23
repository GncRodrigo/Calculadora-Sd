module ctrl(
  input logic clock,
  input logic reset,
  input logic[3:0] dig,
  input logic[3:0] pos,

  output logic [6:0] displays [7:0] // 8 displays, cada um com 7 segmentos, dp que vá pro inferno
);

  logic[8][3:0] data = 0;
  logic ignore [7:0];

// aqui amarra tds 8 displays num vetor, que vai ser amarrado la no top
  display d0 (.data(data[0]), .a(displays[0][6]), .b(displays[0][5]), .c(displays[0][4]), .d(displays[0][3]), .e(displays[0][2]), .f(displays[0][1]), .g(displays[0][0]), .dp(ignore[0]));
  display d1 (.data(data[1]), .a(displays[1][6]), .b(displays[1][5]), .c(displays[1][4]), .d(displays[1][3]), .e(displays[1][2]), .f(displays[1][1]), .g(displays[1][0]), .dp(ignore[1]));
  display d2 (.data(data[2]), .a(displays[2][6]), .b(displays[2][5]), .c(displays[2][4]), .d(displays[2][3]), .e(displays[2][2]), .f(displays[2][1]), .g(displays[2][0]), .dp(ignore[2]));
  display d3 (.data(data[3]), .a(displays[3][6]), .b(displays[3][5]), .c(displays[3][4]), .d(displays[3][3]), .e(displays[3][2]), .f(displays[3][1]), .g(displays[3][0]), .dp(ignore[3]));
  display d4 (.data(data[4]), .a(displays[4][6]), .b(displays[4][5]), .c(displays[4][4]), .d(displays[4][3]), .e(displays[4][2]), .f(displays[4][1]), .g(displays[4][0]), .dp(ignore[4]));
  display d5 (.data(data[5]), .a(displays[5][6]), .b(displays[5][5]), .c(displays[5][4]), .d(displays[5][3]), .e(displays[5][2]), .f(displays[5][1]), .g(displays[5][0]), .dp(ignore[5]));
  display d6 (.data(data[6]), .a(displays[6][6]), .b(displays[6][5]), .c(displays[6][4]), .d(displays[6][3]), .e(displays[6][2]), .f(displays[6][1]), .g(displays[6][0]), .dp(ignore[6]));
  display d7 (.data(data[7]), .a(displays[7][6]), .b(displays[7][5]), .c(displays[7][4]), .d(displays[7][3]), .e(displays[7][2]), .f(displays[7][1]), .g(displays[7][0]), .dp(ignore[7]));


  always @(posedge clock, posedge reset) begin

    if(reset == 1) begin
      data[0] <= 0;
      data[1] <= 0;
      data[2] <= 0;
      data[3] <= 0;
      data[4] <= 0;
      data[5] <= 0;
      data[6] <= 0;
      data[7] <= 0;
    end else begin
      if(pos < 9 && dig < 10) begin
        data[pos-1] <= dig;
      end
    end

  end

endmodule