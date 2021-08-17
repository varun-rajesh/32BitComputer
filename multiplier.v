module multiplier_unsigned(input clk, reset, input[31 : 0] a, b, output[63 : 0] out, output ready);

  wire[31 : 0] count, b_p, reg_out_added;
  wire[63 : 0] reg_in, reg_out, reg_bp, reg_out_shifted;

  assign b_p = (reg_out[0] == 1) ? b : 32'b0;
  assign reg_in = (count == 0) ? {1'b0, ((a[0] == 1) ? b : 32'b0), a[31 : 1]} : reg_out_shifted;
  assign reg_bp = (count == 0) ? reg_in : reg_out;
  assign ready = (count == 32'h1F);
  assign out = reg_out_shifted;

  counter counter(
    .clk (clk),
    .reset (reset),
    .load (1'b0),
    .limit (32'h20),
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

  add add(
    .a (reg_bp[63 : 32]),
    .b (b_p),
    .c_in (1'b0),
    .c (reg_out_added),
    .overflow ()
  );

  sixtyfour_shift_right_unsigned sfsru(
    .in ({reg_out_added, reg_bp[31 : 0]}),
    .out (reg_out_shifted)
  );
endmodule
