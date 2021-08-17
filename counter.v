module counter(input clk, reset, load, input[7:0] limit, load_val, output[7:0] count);

  wire[7:0] n, m;
  wire[7:0] count_bar;
  wire[7:0] count_p;
  wire carry;

  d_ff dff[7:0](
    .clk (clk),
    .d (m),
    .preset (1'b1),
    .clear (reset),
    .q (count),
    .q_bar (count_bar)
  );

  add a(
    .a (count),
    .b (8'b1),
    .c (count_p),
    .carry (carry)
  );

  byte_mux mux0(
    .a (8'b00000000),
    .b (count_p),
    .sel (count_p == limit),
    .out (n)
  );

  byte_mux mux1(
    .a (load_val),
    .b (n),
    .sel (load),
    .out (m)
  );

endmodule
