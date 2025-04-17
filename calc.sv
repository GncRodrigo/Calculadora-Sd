module calc(
input logic clock,
input logic reset,
input logic[3:0] cmd,

output logic[1:0] status,
output logic[3:0] data,
output logic[3:0] pos,

);

// maquina de estados para ter: ESPERA_A, ESPERA_B, OP, RESULT, ERRO, OCUPADA
typedef enum logic[2:0] {  

    ESPERA_A = 3'b000,
    ESPERA_B = 3'b001,
    OP       = 3'b010,
    ERRO     = 3'b011,
    RESULT   = 3'b1000

} estados_calc;
// EA = estado atual, PE = próximo estado
estados_calc    EA, PE;
//começa sempre esperando registrador A
always_ff @(posedge clock, posedge reset)begin
    if(reset) begin
        EA <= ESPERA_A;
    end
    else    begin
        EA <= PE;
    end

end


logic[26:0]digits;
logic[26:0]regA, regB;
logic[3:0] operacao;

always @(posedge clock, posedge reset)begin
    if (reset) begin
    digits <= 0;    
    end
        else begin
            case(EA)
                ESPERA_A:begin
                if(cmd <= 4'd9)begin digits <= (digits * 10) + cmd; PE <= EA end
                else begin  
                regA <= digits;
                digits <= 0;
                PE <= OP;
                end
             end
            
                OP: begin
                if(cmd == 4'b1111)begin PE <= ESPERA_A; end
                operacao <= cmd;
                PE <= ESPERA_B;

                end

                ESPERA_B: begin
                if(cmd <= 4'd9)begin digits <= (digits * 10) + cmd; PE <= EA end
                else begin
                regB <= digits;
                digits <= 0;
                PE <= RESULT;
                end
            end

                RESULT: begin
                    case(operacao)
                    4'b1010: digits <= regA + regB; PE <= ESPERA_A;
                    4'b1011: digits <= regA - regB; PE <= ESPERA_A;
                    4'b1100:  //multiplicaçao tem q ser implementada usando somas sucessivas, sem saco pra fz agr.
                    default: PE <= ERRO;

                    endcase
                    

                end

                ERRO: begin
                    // sei la o que colocar, teria q mostra erro na tela, nao sei cm faz
                    PE <= EA;
                end

             endcase



    end
end







/*


TENTEI FAZER A LOGICA DE ENVIAR PRO DISPLAY MAS NAO TA CERTO, TA ENVIANDO AS ATUALIZAÇOES DOS DIGITS
COMBINACIONAMENTE, POREM O QUE ENVIA PRO DISPLAY ESTÁ SEQUENCIAL, O QUE PODE ACARRETAR EM UM DESCOMPASSO
JÁ QUE TIPO, PODE SER Q EU DIGITE ALGO NO CMD, AI O CLOCK BATE, O INDEX PASSA, E COMO EU DIGITEI ALGO NOVO,
O QUE ESTAVA NO DIGITS É EMPURRADO PRA ESQUERDA, DAI O DISPLAY MANDA IMPRIMIR DENOVO A MESMA COISA. PORRA

atualizando, o bagulho pra mostra o display é uma desgraça, não sei como fz
quase terminei a maquina de estados e o troço do display ainda eh um misterio

// pra mapear os valores num vetor, e mandar pro display
logic [3:0] values [7:0];

always_comb begin
logic [26:0] temp;
temp = digits;

values[0] <= temp % 10; temp = temp/10;
values[1] <= temp % 10; temp = temp/10;
values[2] <= temp % 10; temp = temp/10;
values[3] <= temp % 10; temp = temp/10;
values[4] <= temp % 10; temp = temp/10;
values[5] <= temp % 10; temp = temp/10;
values[6] <= temp % 10; temp = temp/10;
values[7] <= temp % 10; 

end


// envia pro display, data e pos 
logic [2:0] idx;


always_ff @(posedge clock or posedge reset) begin
    if (reset or cmd >= 4'b1010) begin
        idx <= 3'd0;
    end else begin
        data <= values[idx];
        pos  <= idx;

        if (idx == 3'd7)
            idx <= 3'd0;
        else
            idx <= idx + 1;
    end
end


*/





endmodule