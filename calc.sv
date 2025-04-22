module calc (
    input  logic clock,
    input  logic reset,
    input  logic [3:0] cmd,

    output logic [1:0] status,
    output logic [3:0] data,
    output logic [3:0] pos
);

    localparam ESPERA_A = 3'b000;
    localparam ESPERA_B = 3'b001;
    localparam OP       = 3'b010;
    localparam RESULT   = 3'b011;
    localparam ERRO     = 3'b100;

    logic [2:0] EA;
    logic [2:0] PE;


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

    logic prontoB = 0; // flag para indicar que o segundo número foi digitado (copilot descobriu rapidão)

    // Bloco sequencial: lógica da operação
    always_ff @(posedge clock or posedge reset) begin
        if (reset) begin        // reset zera tudo, evita de ficar lixo
            digits   <= 0;
            regA     <= 0;
            regB     <= 0;
            regAux   <= 0;
            count    <= 0;
            status   <= 2'b10;   // como o status 00 significa erro, 01 ocupado, e 10 pronto. O STATUS PRONTO SIGNIFICA: PRONTO PARA RECEBER COMANDO DO CMD
            operacao <= 0;
            end else begin

            case (EA)

                ESPERA_A: begin
                    if( status == 2'b10) begin
                        if (cmd <= 4'd9) begin
                            digits <= (digits * 10) + cmd; // faz o deslocamento e adiciona

                       
                        end else if (cmd == 4'b1111) begin
                            digits <= digits / 10; // aqui ta rolando o backspace
                     
                        end 
                end
                end

                OP: begin
                    regA <= digits; // Salva o valor em regA
                    digits <= 0;
                    if( status == 2'b10) begin
                    operacao <= cmd;
                    end
                end

                ESPERA_B: begin
                    prontoB <= 0;

                    if( status == 2'b10) begin
                        if (cmd <= 4'd9) begin
                            digits <= (digits * 10) + cmd; // Adiciona o novo dígito
                        end else if (cmd == 4'b1111) begin
                         digits <= digits / 10; // Remove o último dígito

                            end else begin
                                regB <= digits; // Salva o valor em regB
                                digits <= 0;
                                prontoB <= 1; // Indica que o segundo número foi digitado (to surpreso com o copilot, da medo)
                            end
                    end
                end

                RESULT: begin
                    case (operacao)
                        4'b1010: begin 
                            digits <= regA + regB;  
                            status <= 2'b01; // Soma, status ocupado
                        end
                        4'b1011: begin 
                            digits <= regA - regB;  
                            status <= 2'b01; // Subtração, status ocupado
                        end
                        4'b1100: begin // Multiplicação por somas sucessivas
                            if (status == 2'b01) begin
                                digits <= 0;
                                count  <= (regA > regB) ? regB : regA;  // Define o menor valor como contador
                                regAux <= (regA > regB) ? regA : regB;  // Define o maior valor
                            end else if (count > 0) begin
                                digits <= digits + regAux; // Soma sucessiva
                                count  <= count - 1;       // Decrementa o contador
                            end else if (count == 0) begin
                                operacao <= 0;
                                status <= 2'b10; // Pronto após a multiplicação
                            end
                        end
                        default: begin
                            digits <= 27'd0; 
                            status <= 2'b00; // Erro
                        end
                    endcase

                
                end

                ERRO: begin
                    digits <= 27'd0; // codigo de erro
                    status <= 2'b00; //status ERRO
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
                    PE = OP;
                end
                else begin PE = ESPERA_A;
                end
            OP:
                PE = ESPERA_B;

            ESPERA_B:
            if (prontoB) begin
                if (cmd == 4'b1110) 
                begin
                    PE = RESULT;
                end 

                else if (cmd > 4'b1010 && cmd < 4'b1110) 
                begin
                    PE = ERRO;
                end
                
            end
            RESULT: begin
                case (operacao)
                    4'b1010, 4'b1011:
                        PE = ESPERA_A;
                    4'b1100:
                        if (status != 2'b01 && count == 0)begin
                            PE = ESPERA_A;
                        end
                        else begin
                            PE = RESULT;
                        end
                    default:
                        PE = ERRO;
                endcase
            end

            ERRO:
                PE = ERRO; //fica no erro até dar reset

        endcase
    end

//LÓGICA PARA OS DISPLAYS

logic [3:0] values [7:0];
logic [26:0] temp;

always_comb begin
    if (status == 00 || (status == 2'b01 && operacao != 4'b1100)) begin
        // Exibe os valores apenas se o status for ocupado, exceto durante a multi
        case (pos)
            4'd0: data = values[0]; // Display 0
            4'd1: data = values[1]; // Display 1
            4'd2: data = values[2]; // Display 2
            4'd3: data = values[3]; // Display 3
            4'd4: data = values[4]; // Display 4
            4'd5: data = values[5]; // Display 5
            4'd6: data = values[6]; // Display 6
            4'd7: data = values[7]; // Display 7
            default: data = 4'd0;   // valor padrao
        endcase
    end else begin
        data = 4'd0; // mostra 0 durante a multiplicacao
    end
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

// vai demora 7 clocks pra mostra o display td
always_ff @(posedge clock or posedge reset) begin
    if (reset) begin
        pos <= 0;
        
    end else if (pos > 7) begin
        // Reseta pos após todos os displays serem atualizados
        pos <= 0;
    end else if (status == 00 || (status == 2'b01 && operacao != 4'b1100)) begin
        // Incrementa pos enquanto ocupado
        pos <= pos + 1;
    end else if (status == 2'b10) begin
        // Reseta pos quando o status muda para pronto
        pos <= 0;
    end
end

endmodule