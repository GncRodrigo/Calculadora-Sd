`timescale 1ns/100ps

module tb_display;

  // sinais internos do tb
  logic[3:0] data;
  
  logic a;
  logic b;
  logic c;
  logic d;
  logic e;
  logic f;
  logic g;
  logic dp;

  // cria um novo display e conecta as entradas (data) e 
  // saídas (a, b, c, d, e, f, g e dp) do display aos 
  // registradores do tb
  display display1(
    .a(a), .b(b), .c(c), .d(d),
    .e(e), .f(f), .g(g), .dp(dp),
    .data(data)
  );

  // inicia os testes
  initial begin
    for (int i = 0; i < 10; i++) begin
      data <= i; #2;
    end
  end
endmodule
