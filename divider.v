module divide_unsigned(input clk, reset, input[31 : 0] a, b, output[31 : 0] quotient, remainder, output ready);

  wire[63 : 0] reg_in, reg_out, reg_out_shifted;
  wire[31 : 0] count, reg_out_subtracted, reg_out_added;
  wire overflow;

  assign reg_in = (count == 0) ? {31'b0, a, 1'b0} : {reg_out_shifted[63 : 1], !overflow};
  assign quotient = {reg_out_shifted[31 : 1], !overflow};
  assign remainder = reg_out_added;
  assign ready = (count == 32'h20);

  counter counter(
    .clk (clk),
    .reset (reset),
    .load (1'b0),
    .limit (32'h21),
    .load_val (),
    .count (count)
  );

  two_word_register twr(
    .clk (clk),
    .enable_in (1'b1),
    .enable_out (1'b1),
    .reset (reset),
    .data (reg_in),
    .out (reg_out)
  );

  subtract sub(
    .a (reg_out[63 : 32]),
    .b (b),
    .c (reg_out_subtracted),
    .overflow (overflow)
  );

  add add(
    .a (reg_out_subtracted),
    .b ((overflow == 1) ? b : 32'b0),
    .c_in (1'b0),
    .c (reg_out_added),
    .overflow ()
  );

  sixtyfour_shift_left sfsl(
    .in ({reg_out_added, reg_out[31 : 0]}),
    .out (reg_out_shifted)
  );

endmodule
