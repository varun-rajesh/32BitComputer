module subtract(input[31 : 0] a, b, output[31 : 0] c);
  wire[31 : 0] tc_b;
  wire[31 : 0] computed_c;
  wire computed_overflow;
  wire skip;

  add twos_complement(
    .a (~b),
    .b (32'b1),
    .c (tc_b),
    .overflow (skip)
  );

  add add(
    .a (a),
    .b (tc_b),
    .c (computed_c),
    .overflow (computed_overflow)
  );

  mux overflow_mux(
    .a (1'b0),
    .b (!computed_overflow),
    .sel (skip),
    .out (overflow)
  );

  word_mux difference_mux(
    .a (a),
    .b (computed_c),
    .sel (skip),
    .out (c)
  );

endmodule
