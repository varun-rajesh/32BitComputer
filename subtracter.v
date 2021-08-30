module subtract(input[31 : 0] a, b, output[31 : 0] c, output overflow);
  wire[31 : 0] tc_b;
  wire[31 : 0] computed_c;
  wire computed_overflow;
  wire skip;

  add twos_complement(
    .a (~b),
    .b (32'b0),
    .c_in (1'b1),
    .c (tc_b),
    .overflow (skip)
  );

  add add(
    .a (a),
    .b (tc_b),
    .c_in (1'b0),
    .c (computed_c),
    .overflow (computed_overflow)
  );

  assign overflow = (skip) ? 1'b0 : !computed_overflow;
  assign c = (skip) ? a : computed_c;

endmodule
