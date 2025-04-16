module calculadora(
    input logic [3:0] cmd,
    input logic reset,
    input logic clock,
    

    output logic [1:0] status,
    output logic [3:0] data,
    output logic [3:0] position
);

    ctrl controller ( .reset(reset), .clock(clock), .num(data), .pos(position));
        logic [3:0] aux
    always @(posedge clock, posedge reset) begin
        if (reset == 1)  cmd = 0;
        case (cmd)
            4'b0000 : 4'b0000
            4'b0001 : 1
            4'b0010 : 2
            4'b0011 : 3
            4'b0100 : 4
            4'b0101 : 5
            4'b0110 : 6
            4'b0111 : 7
            4'b1000 : 8
            4'b1001 : 9
            4'b1010 : +
            4'b1011 : -
            4'b1100 : *
            4'b1110 : begin
                
    end
            4'b1111 : delete
            
            
            default: 
        endcase
    end


endmodule