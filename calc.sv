module calc (
    input  logic clock,
    input  logic reset,
    input  logic [3:0] cmd,

    output logic [1:0] status,
    output logic [3:0] data,
    output logic [3:0] pos
);

    typedef enum logic [2:0] {
        ESPERA_A = 3'b000,
        ESPERA_B = 3'b001,
        OP       = 3'b010,
        RESULT   = 3'b011,
        ERRO     = 3'b100
    } estados_calc;

    estados_calc EA, PE;

    logic [26:0] digits;
    logic [26:0] regA, regB, regAux;
    logic [3:0]  operacao;
    logic [26:0] count;
    logic        busy;

    assign data = digits[3:0];
    assign pos = 4'd0;

    // Bloco sequencial: atualização do estado
    always_ff @(posedge clock or posedge reset) begin
        if (reset) begin
            EA <= ESPERA_A;
        end else begin
            EA <= PE;
        end
    end

    // Bloco sequencial: lógica da operação
    always_ff @(posedge clock or posedge reset) begin
        if (reset) begin        // reset zera tudo, evita de ficar lixo
            digits   <= 0;
            regA     <= 0;
            regB     <= 0;
            regAux   <= 0;
            count    <= 0;
            busy     <= 0;
            operacao <= 0;
        end else begin
            case (EA)

                ESPERA_A: begin
                    if (cmd <= 4'd9)
                        digits <= (digits * 10) + cmd;
                    else begin
                        regA   <= digits;
                        digits <= 0;
                    end
                end

                OP: begin
                    operacao <= cmd;
                end

                ESPERA_B: begin
                    if (cmd <= 4'd9)
                        digits <= (digits * 10) + cmd;
                    else begin
                        regB   <= digits;
                        digits <= 0;
                        busy   <= 0;
                    end
                end

                RESULT: begin
                    case (operacao)
                        4'b1010: digits <= regA + regB; // soma
                        4'b1011: digits <= regA - regB; // subtração
                        4'b1100: begin // multiplicação por somas sucessivas
                            if (!busy) begin
                                digits <= 0;
                                count  <= (regA > regB) ? regB : regA;  // ve qual é maior e pega o menor
                                regAux <= (regA > regB) ? regA : regB;  // pega o maior
                                busy   <= 1;                            // fica "busy"
                            end else if (count > 0) begin               // ciclos para ir calculando
                                digits <= digits + regAux;              // a cada ciclo soma + regAux no digits
                                count  <= count - 1;                    // diminiu os ciclos
                            end else
                                busy <= 0;                              // se não tem mais ciclos, coloca "busy" em false, para poder ir pro proximo estado
                        end
                        default: digits <= 27'hBAD; // codigo de erro, gpt que falou
                    endcase
                end

                ERRO: begin
                    digits <= 27'hBAD; // codigo de erro, gpt que falou
                end

            endcase
        end
    end

    // mudar as posições
    always_comb begin
        PE = EA; // default
        case (EA)
            ESPERA_A:
                if (cmd > 4'd9)
                    PE = OP;

            OP:
                PE = ESPERA_B;

            ESPERA_B:
                if (cmd > 4'd9)
                    PE = RESULT;

            RESULT: begin
                case (operacao)
                    4'b1010, 4'b1011:
                        PE = ESPERA_A;
                    4'b1100:
                        if (busy == 0 && count == 0)
                            PE = ESPERA_A;
                        else
                            PE = RESULT;
                    default:
                        PE = ERRO;
                endcase
            end

            ERRO:
                PE = ESPERA_A;

            default:
                PE = ERRO;
        endcase
    end

endmodule



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