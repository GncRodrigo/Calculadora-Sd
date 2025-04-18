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
    logic [3:0] display_counter;                // guarda em qual display tá

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
            display_counter <= 0;
            regA     <= 0;
            regB     <= 0;
            regAux   <= 0;
            count    <= 0;
            status   <= 2'b11;   // como o status 00 significa erro, 01 ocupado, e 10 pronto. Assumi que 11 não significa nada
            operacao <= 0;
        end else begin
            case (EA)

                ESPERA_A: begin
                    status   <= 2'b11; // DEFAULT status
                    if (cmd <= 4'd9) begin
                        digits <= (digits * 10) + cmd; // faz o deslocamento e adiciona

                        pos <= display_counter; // coloca pos, que ta ligado com o pos do ctrl na posição atual
                        data <= cmd;            // coloca a entrada (numero) em data (dig em ctrl) 
                        display_counter <= display_counter + 1; // passa pra proxima posição

                    end else if (cmd == 4'b1111) begin
                        digits <= digits / 10; // aqui ta rolando o backspace
                        data <= 4'b0;          // apaga o atual
                        display_counter <= display_counter - 1; // volta um espaço
                        pos <= display_counter;                 // att pos
                    end else begin
                        regA <= digits; // salva no regA
                        digits <= 0; // zera o digits e consequentemente o display
                        display_counter <= 0; // zera a posição antes de ir para ESPERA_B
                        data[0] <= 0; // limpa os displays ao sair de ESPERA_A
                        data[1] <= 0; 
                        data[2] <= 0; 
                        data[3] <= 0; 
                        data[4] <= 0; 
                        data[5] <= 0; 
                        data[6] <= 0; 
                        data[7] <= 0; 

                    end
                end

                OP: begin
                    operacao <= cmd;
                end

                ESPERA_B: begin
                    if (cmd <= 4'd9) begin
                        digits <= (digits * 10) + cmd; // Adiciona o novo dígito

                        pos <= display_counter;
                        data <= cmd;
                        display_counter <= display_counter + 1;

                    end else if (cmd == 4'b1111) begin
                        digits <= digits / 10; // Remove o último dígito

                        data <= 4'b0;
                        display_counter <= display_counter - 1;
                        pos <= display_counter;

                    end else begin
                        regB <= digits; // Salva o valor em regB
                        digits <= 0;
                        display_counter = 0;
                        data[0] <= 0; // limpa os displays ao sair de ESPERA_B
                        data[1] <= 0; 
                        data[2] <= 0; 
                        data[3] <= 0; 
                        data[4] <= 0; 
                        data[5] <= 0; 
                        data[6] <= 0; 
                        data[7] <= 0; 
                        pos <= display_counter; // coloca pos no inicio para os resultados
                    end
                end

                RESULT: begin
                    case (operacao)
                        4'b1010: digits <= regA + regB; status <= 2'b10; // soma // status pronto //não precisa de begin e end?, usa mais de uma linha
                        4'b1011: digits <= regA - regB; status <= 2'b10; // subtração // status pronto
                        4'b1100: begin // multiplicação por somas sucessivas
                            if (status != 2'b01) begin
                                digits <= 0;
                                count  <= (regA > regB) ? regB : regA;  // ve qual é maior e pega o menor
                                regAux <= (regA > regB) ? regA : regB;  // pega o maior
                                status   <= 2'b01;                            // status <= ocupado
                            end else if (count > 0) begin               // ciclos para ir calculando
                                digits <= digits + regAux;              // a cada ciclo soma + regAux no digits
                                count  <= count - 1;                    // diminiu os ciclos
                            end else
                                status <= 2'b10;                       // se nao tem mais ciclos, coloca "status" em pronto
                        end
                        default: digits <= 27'hBAD; // codigo de erro, gpt que falou
                    endcase

                    if (status == 2'b10) begin // se ta pronto, mostra o resultado, fazer em mais ciclos fica menor mas gasta mais ciclos
                        data[0] <= digits[3:0]; 
                        data[1] <= digits[7:4]; 
                        data[2] <= digits[11:8]; 
                        data[3] <= digits[15:12]; 
                        data[4] <= digits[19:16]; 
                        data[5] <= digits[23:20]; 
                        data[6] <= digits[27:24]; 
                        data[7] <= 0;
                    end 
                end

                ERRO: begin
                    digits <= 27'hBAD; // codigo de erro, gpt que falou
                    status <= 0; //status ERRO
                end

            endcase
        end
    end

    // mudar as posições
    always_comb begin
        PE = EA; // default
        case (EA)
            ESPERA_A:
                if (cmd > 4'd9)begin
                    PE <= OP;
                end
                else PE <= ESPERA_A;
            OP:
                PE <= ESPERA_B;

            ESPERA_B:
                if (cmd == 4'b1110) begin
                    PE <= RESULT;
                end else if (cmd > 4'b1010 && cmd < 4'b1110) begin
                    PE <= ERRO;
                end
            RESULT: begin
                case (operacao)
                    4'b1010, 4'b1011:
                        PE <= ESPERA_A;
                    4'b1100:
                        if (status != 2'b01 && count == 0)begin
                            PE <= ESPERA_A;
                        end
                        else begin
                            PE <= RESULT;
                        end
                    default:
                        PE <= ERRO;
                endcase
            end

            ERRO:
                PE <= ERRO; //fica no erro até dar reset

        endcase
    end

endmodule