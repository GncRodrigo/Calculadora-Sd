module calc_top(
    input logic [3:0] cmd,
    input logic reset,
    input logic clock
 
);

logic [3:0] data;
logic [3:0] pos;
logic [1:0] status;

calc calculadera(.clock(clock), .reset(reset), .cmd(cmd), .status(status) ,.data(data), .pos(pos));

ctrl controladoro(.clock(clock), .reset(reset), .dig(data), .pos(pos));

endmodule