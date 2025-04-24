module calc (
    input  logic clock,
    input  logic reset,
    input  logic [3:0] cmd,

    output logic [1:0] status,
    output logic [3:0] data,
    output logic [3:0] pos,
    output logic [2:0] EA,
    output logic [2:0] PE,
    output logic [2:0] SA


    
);

    localparam ESPERA_A = 3'b000;
    localparam ESPERA_B = 3'b001;
    localparam OP       = 3'b010;
    localparam RESULT   = 3'b011;
    localparam ERRO     = 3'b100;
    localparam PRINT    = 3'b101;


    
    logic [26:0] digits;

    logic [26:0] regA, regB, regAux;
    logic [3:0]  operacao;
    logic [26:0] count;

    logic [3:0] values [7:0];
    logic [26:0] temp;
    


    // Bloco sequencial: atualização do estado
    always_ff @(posedge clock or posedge reset) begin
        if (reset) begin
            EA <= PRINT;
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
            status   <= 2'b10;   // como o status 00 significa erro, 01 ocupado, e 10 pronto. O STATUS PRONTO SIGNIFICA: PRONTO PARA RECEBER COMANDO DO CMD
            operacao <= 0;
            pos <= 4'b0000;
            end else if(clock) begin

            case (EA)

                ESPERA_A: begin
                    if( status == 2'b10) begin
                        if (cmd <= 4'd9) begin
                            digits <= (digits * 10) + cmd; // faz o deslocamento e adiciona
                            status <= 2'b01;

                        end else if (cmd == 4'b1111) begin
                            digits <= digits / 10; // aqui ta rolando o backspace
                            status <= 2'b01;
                        end 
                end
                end

                OP: begin
                    if(cmd != operacao)begin
                        regA <= digits; // Salva o valor em regA
                        digits <= 0;
                      
                    end
                      if(cmd > 4'd9) begin
                      operacao <= cmd;
                        status <= 2'b01;end
                    //ATUALIZA OS DISPLAYS
                    // CMD MUDADINHO
                end

                ESPERA_B: begin
                    

                    if( status == 2'b10) begin
                        if (cmd <= 4'd9) begin
                            digits <= (digits * 10) + cmd; // Adiciona o novo dígito
                            status <= 2'b01;
                        end else if (cmd == 4'b1111) begin
                            digits <= digits / 10; // Remove o último dígito
                            status <= 2'b01;
                            end 
                            else if(cmd == 4'b1110) begin // se for igual result salva e faz tudo
                                regB <= digits; // Salva o valor em regB
                                digits <= 0;
                                status <= 2'b01;
                            end
                    end
                end

                RESULT: begin
                    $display("OPERAÇÃO = %b", operacao);
                    $display("STATUS = %b", status);
                    if (status == 2'b10) begin
                        
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
                            status <= 2'b01;
                            if ((status == 2'b01) && (count == 0)) begin
                                count  <= (regA > regB) ? regB : regA;  // Define o menor valor como contador
                                regAux <= (regA > regB) ? regA : regB;  // Define o maior valor
                            end else if (count > 0) begin
                                digits <= digits + regAux; // Soma sucessiva
                                count  <= count - 1;       // Decrementa o contador
                            end else if (count == 0) begin
                                operacao <= 0;
                                status <= 2'b01; // Ocupado após mult
                            end
                        end
                        default: begin
                            
                             // Erro
                        end
                    endcase
                    end
                
                end

                PRINT:begin

                //LÓGICA PARA OS DISPLAYS
               // MEXEDOR DA POSIÇÃO
                 if (pos > 4'b0111) begin
                 // Reseta pos após todos os displays serem atualizados
                        pos <= 4'b0000;
                        status <= 2'b10;
                end else 
                
                
            
                if(pos == 0)begin temp <= digits;end
                // mapeia para o values o que estiver no digits, tudo isso combinacionalmente
 
                values[pos] <= temp % 10; temp <= temp/10; 
                
                // Exibe os valores apenas se o status for ocupado, exceto durante a multi
                 data <= values[pos];
                   
                // Incrementa pos enquanto ocupado
                    pos <= pos + 1;
                end


                ERRO: begin
                    status <= 2'b00; //status ERRO
                end

                
            endcase
                

                end 
        end
    
    // mudar as maquina de estados
    always_ff @(posedge clock, posedge reset) begin
        if(reset) begin SA <= ESPERA_A;  end
        else begin
       
        case (EA)
            ESPERA_A: begin
                if ((cmd > 4'd9)&&(cmd < 4'd11))begin
                    PE <= OP;
                    
                end
                else if(cmd < 4'd10 && cmd != 0) begin PE <= PRINT; SA <= ESPERA_A;  end
                
            end
            OP: if(status == 4'b10 && cmd < 4'b1010) PE <= ESPERA_B; 
            else begin PE <= PRINT; SA <= OP; end
                
            ESPERA_B:
            
                if (cmd == 4'b1110) 
                begin
                    PE <= PRINT;
                    SA <= RESULT;
                end 

                else if (cmd >= 4'b1010 && cmd < 4'b1110)
                begin
                    PE <= ERRO;
                end
                else begin PE <= PRINT; SA <= ESPERA_B; end
                
            RESULT: begin
                if( status == 2'b10)begin
                case (operacao)
                    4'b1010: begin PE <= PRINT; SA <= ESPERA_A; end

                    4'b1011: begin PE <= PRINT; SA <= ESPERA_A; end

                    4'b1100:begin
                        if (status != 2'b01 && count == 0)begin
                            PE <= PRINT;
                            SA <= ESPERA_A;
                        end
                        else begin
                            PE <= RESULT;
                        end
                    end
                    default:
                        PE <= ERRO;
                
                endcase
                end else PE <= RESULT;
            end

            PRINT:begin
                if(status == 2'b10) PE <= SA;
                else PE <= PRINT;

            end

            ERRO:
                PE <= ERRO; //fica no erro até dar reset

        endcase
        end
    end



endmodule