module calc(
input logic clock,
input logic reset,
input logic[3:0] cmd,

output logic[1:0] status,
output logic[3:0] data,
output logic[3:0] pos

);
logic[26:0]digits;

ctrl display_ctrl(.clock(clock), .reset(reset), .dig(data), .pos(pos));

always @(posedge clock, posedge reset)begin
    if (reset) begin
    digits <= 0;

    else
    case(cmd)

    4'b0000:digits <= (digits * 10) + cmd;
    4'b0001:digits <= (digits * 10) + cmd;
    4'b0010:digits <= (digits * 10) + cmd;
    4'b0011:digits <= (digits * 10) + cmd;
    4'b0100:digits <= (digits * 10) + cmd;
    4'b0101:digits <= (digits * 10) + cmd;
    4'b0110:digits <= (digits * 10) + cmd;
    4'b0111:digits <= (digits * 10) + cmd;
    4'b1000:digits <= (digits * 10) + cmd;
    4'b1001:digits <= (digits * 10) + cmd;
    4'b1010://mais
    4'b1011://sub
    4'b1100://mul
    4'b1110://result
    4'b1111://apagar

    endcase

    end


end



endmodule