module counter(input clk, reset, load, input[31:0] limit, load_val, output[31:0] count);

  wire[31:0] n, m;
  wire[31:0] count_bar;
  wire[31:0] count_p;

  d_ff dff[31:0](
    .clk (clk),
    .d (m),
    .preset (1'b1),
    .clear (reset),
    .q (count),
    .q_bar (count_bar)
  );

  add a(
    .a (count),
    .b (32'b1),
    .c_in (1'b0),
    .c (count_p),
    .overflow ()
  );

  assign n = (count_p == limit) ? 32'b0 : count_p;
  assign m = (load) ? load_val : n;

endmodule
