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
            status   <= 2'b11;   // como o status 00 significa erro, 01 ocupado, e 10 pronto. Assumi que 11 não significa nada
            operacao <= 0;
'        end else begin
            case (EA)

                ESPERA_A: begin
                    status   <= 2'b11; // DEFAULT status
                    if (cmd <= 4'd9) begin
                        digits <= (digits * 10) + cmd; // faz o deslocamento e adiciona

                       
                    end else if (cmd == 4'b1111) begin
                        digits <= digits / 10; // aqui ta rolando o backspace
                     
                    end else begin
                        regA <= digits; // salva no regA
                        digits <= 0; // zera o digits e consequentemente o display
                       
                      
                    end
                end

                OP: begin
                    operacao <= cmd;
                end

                ESPERA_B: begin
                    if (cmd <= 4'd9) begin
                        digits <= (digits * 10) + cmd; // Adiciona o novo dígito


                    end else if (cmd == 4'b1111) begin
                        digits <= digits / 10; // Remove o último dígito

                

                    end else begin
                        regB <= digits; // Salva o valor em regB
                        digits <= 0;
                        
                    end
                end

                RESULT: begin
                    case (operacao)
                        4'b1010: begin digits <= regA + regB; status <= 2'b10; end // soma // status pronto 
                        4'b1011: begin digits <= regA - regB; status <= 2'b10; end // subtração // status pronto
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

//LÓGICA PARA OS DISPLAYS

logic [3:0] values [7:0];
logic [26:0] temp;

always_comb begin

    case (pos)
        4'd0: data = values[0]; // Display 0
        4'd1: data = values[1]; // Display 1
        4'd2: data = values[2]; // Display 2
        4'd3: data = values[3]; // Display 3
        4'd4: data = values[4]; // Display 4
        4'd5: data = values[5]; // Display 5
        4'd6: data = values[6]; // Display 6
        4'd7: data = values[7]; // Display 7
        default: data = 4'd0;   // Valor padrão
 
    endcase
end

 
always_comb begin
temp = digits;
// mapeia para o values o que estiver no digits, tudo isso combinacionalmente
 
values[0] = temp % 10; temp = temp/10; 
values[1] = temp % 10; temp = temp/10; 
values[2] = temp % 10; temp = temp/10; 
values[3] = temp % 10; temp = temp/10; 
values[4] = temp % 10; temp = temp/10; 
values[5] = temp % 10; temp = temp/10; 
values[6] = temp % 10; temp = temp/10; 
values[7] = temp % 10; 

end

// vai demora 7 clocks pra mostra o display td, unico modo q achei de fz
always_ff @(posedge clock or posedge reset) begin
    if (reset)begin
        pos <= 0;
    end
    else if (pos>7)begin
        pos <= 0;
    end
    else begin
        pos <= pos + 1;
    end
end




endmodule