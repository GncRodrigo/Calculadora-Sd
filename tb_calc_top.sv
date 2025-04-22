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

  // Teste inicial
  initial begin
    // Inicialização
    reset = 1;
    cmd = 4'b0000; // Nenhum comando
    #4;

    reset = 0; // Libera o reset
    #4;

    // Teste: Digitar apenas um número
    $display("Teste: Digitar apenas um número");
    cmd = 4'b0001; // Digita '1'
    #2;
    if (digits != 27'd1) begin
      $display("Erro: digits esperado = 1, obtido = %0d", digits);
    end else begin
      $display("Sucesso: digits = %0d", digits);
    end

    // Finaliza a simulação
    $finish;
  end

endmodule