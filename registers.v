module sb_register(input clk, enable_in, enable_out, reset, data, output out);
  wire q;

  assign out = (enable_out) ? q : 1'bZ;

  d_ff dff(
    .clk (clk),
    .d ((enable_in & data) | (~enable_in & q)),
    .preset (1'b1),
    .clear (reset),
    .q (q),
    .q_bar ()
  );
endmodule

module word_register(input clk, enable_in, enable_out, reset, input[31:0] data, output[31:0] out);

  sb_register sb[31:0](
    .clk (clk),
    .enable_in (enable_in),
    .enable_out (enable_out),
    .reset (reset),
    .data (data),
    .out (out)
  );

endmodule

module two_word_register(input clk, enable_in, enable_out, reset, input[63:0] data, output[63:0] out);

  sb_register sb[63:0](
    .clk (clk),
    .enable_in (enable_in),
    .enable_out (enable_out),
    .reset (reset),
    .data (data),
    .out (out)
  );

endmodule

//set, reset, preset, clear are active low
module sr_latch(input set, reset, preset, clear, output q, q_bar);
  assign q = ~(set & preset & q_bar);
  assign q_bar = ~(reset & clear & q);
endmodule

//enable, set, and reset are active high; preset and clear are active low
module gated_sr_latch(input enable, set, reset, preset, clear, output q, q_bar);
  sr_latch sr(
      .set (~(set & enable)),
      .reset (~(reset & enable)),
      .preset (preset),
      .clear (clear),
      .q (q),
      .q_bar (q_bar)
  );
endmodule

//negative edge triggered; d is active high; preset and clear are active low
module d_ff(input clk, d, preset, clear, output q, q_bar);

  wire master_q;
  wire master_q_bar;

  gated_sr_latch master_gsr(
    .enable (clk),
    .set (d),
    .reset (~d),
    .preset (preset),
    .clear (clear),
    .q (master_q),
    .q_bar (master_q_bar)
  );

  gated_sr_latch slave_gsr(
    .enable (~clk),
    .set (master_q),
    .reset (master_q_bar),
    .preset (preset),
    .clear (clear),
    .q (q),
    .q_bar (q_bar)
  );
endmodule
