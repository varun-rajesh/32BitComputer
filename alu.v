module alu(input clk, reset, input[11 : 0] funct, input[31 : 0] a, b, output[31 : 0] c, output ready);

  wire multiply_ready, divide_ready;
  wire[31 : 0] add_c, sub_c, divide_q, divide_r;
  wire[63 : 0] multiply_c;

  add add(
    .a (a),
    .b (b),
    .c_in (1'b0),
    .c (add_c),
    .overflow ()
  );

  subtract sub(
    .a (a),
    .b (b),
    .c (sub_c),
    .overflow ()
  );

  multiply_unsigned multiply(
    .clk (clk),
    .reset (reset),
    .a (a),
    .b (b),
    .out (multiply_c),
    .ready (multiply_ready)
  );

  divide_unsigned divide(
    .clk (clk),
    .reset (reset),
    .a (a),
    .b (b),
    .quotient (divide_q),
    .remainder (divide_r),
    .ready (divide_ready)
  );

endmodule
