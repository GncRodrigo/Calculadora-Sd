module ctrl(
  input logic clock,
  input logic reset,
  input logic[3:0] dig,
  input logic[3:0] pos,

  output logic[8] a,
  output logic[8] b,
  output logic[8] c,
  output logic[8] d,
  output logic[8] e,
  output logic[8] f,
  output logic[8] g,
  output logic[8] dp
);

  logic[8][3:0] data = 0;

  display d0 (.data(data[0]),.a(a[0]), .b(b[0]), .c(c[0]), .d(d[0]), .e(e[0]), .f(f[0]), .g(g[0]), .dp(dp[0]));
  display d1 (.data(data[1]),.a(a[1]), .b(b[1]), .c(c[1]), .d(d[1]), .e(e[1]), .f(f[1]), .g(g[1]), .dp(dp[1]));
  display d2 (.data(data[2]),.a(a[2]), .b(b[2]), .c(c[2]), .d(d[2]), .e(e[2]), .f(f[2]), .g(g[2]), .dp(dp[2]));
  display d3 (.data(data[3]),.a(a[3]), .b(b[3]), .c(c[3]), .d(d[3]), .e(e[3]), .f(f[3]), .g(g[3]), .dp(dp[3]));
  display d4 (.data(data[4]),.a(a[4]), .b(b[4]), .c(c[4]), .d(d[4]), .e(e[4]), .f(f[4]), .g(g[4]), .dp(dp[4]));
  display d5 (.data(data[5]),.a(a[5]), .b(b[5]), .c(c[5]), .d(d[5]), .e(e[5]), .f(f[5]), .g(g[5]), .dp(dp[5]));
  display d6 (.data(data[6]),.a(a[6]), .b(b[6]), .c(c[6]), .d(d[6]), .e(e[6]), .f(f[6]), .g(g[6]), .dp(dp[6]));
  display d7 (.data(data[7]),.a(a[7]), .b(b[7]), .c(c[7]), .d(d[7]), .e(e[7]), .f(f[7]), .g(g[7]), .dp(dp[7]));

  always @(posedge clock, negedge reset) begin

    if(reset == 1) begin
      data[0] = 0;
      data[1] = 0;
      data[2] = 0;
      data[3] = 0;
      data[4] = 0;
      data[5] = 0;
      data[6] = 0;
      data[7] = 0;
    end else begin
      if(pos < 8 && dig < 10) begin
        data[pos] = dig;
      end
    end

  end

endmodule