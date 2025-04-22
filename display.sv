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
  logic[9:0] ff [0:9]= {
    10'b1111110_0, // 0
    10'b1100000_0, // 1
    10'b1101101_0, // 2
    10'b1111001_0, // 3
    10'b0110011_0, // 4
    10'b1011011_0, // 5
    10'b0011111_0, // 6
    10'b1110000_0, // 7
    10'b1111111_0, // 8
    10'b1110011_0  // 9
  };

  // conecta a saída ao vetor f, utilizando o índice para selecionar
  // a linha que contém a combinação correta de valores (dígito)
  assign {a, b, c, d, e, f, g, dp} = ff[data];
  

endmodule
