module display(
  input logic[3:0] data,
  output logic a,
  output logic b,
  output logic c,
  output logic d,
  output logic e,
  output logic f,
  output logic g,
  output logic dp
);
  
  // "f" é a função que mapeia as entras em saídas. Neste caso,
  // é declarado como um vetor de 8 posições (8 segmentos do display), contendo
  // 8 bits cada (um para cada possibilidade de dígito a ser mostrado)
  logic[6:0]ff[0:9]= {
    7'b1111110,  // 0
    7'b1100000,  // 1
    7'b1101101,  // 2
    7'b1111001,  // 3
    7'b0110011,  // 4
    7'b1011011,  // 5
    7'b0011111,  // 6
    7'b1110000,  // 7
    7'b1111111,  // 8
    7'b1110011   // 9
  };

  // conecta a saída ao vetor f, utilizando o índice para selecionar
  // a linha que contém a combinação correta de valores (dígito)
  assign {a, b, c, d, e, f, g} = ff[data];

endmodule
