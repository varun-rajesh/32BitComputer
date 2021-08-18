module two_mux(input a, b, sel, output out);
  assign out = (sel & a) | (~sel & b);
endmodule

module two_word_mux(input[63 : 0] a, b, input sel, output[63 : 0] out);
  mux mux[63 : 0](
    .a (a),
    .b (b),
    .sel (sel),
    .out (out)
  );
endmodule

module word_mux(input[31 : 0] a, b, input sel, output[31 : 0] out);
  mux mux[31 : 0](
    .a (a),
    .b (b),
    .sel (sel),
    .out (out)
  );
endmodule

module byte_mux(input[7 : 0] a, b, input sel, output[7 : 0] out);
  mux mux[7 : 0](
    .a (a),
    .b (b),
    .sel (sel),
    .out (out)
  );
endmodule

module thirtytwo_mux(input[31 : 0] a, input[4 : 0] sel, output out);

  wire a_p, b_p;

  sixteen_mux muxa(
    .a (a[15 : 0]),
    .sel (sel[3 : 0]),
    .out (a_p)
  );

  sixteen_mux muxb(
    .a (a[31 : 16]),
    .sel (sel[3 : 0]),
    .out (b_p)
  );

  two_mux mux(
    .a (b_p),
    .b (a_p),
    .sel (sel[4]),
    .out (out)
  );
endmodule

module sixteen_mux(input[15 : 0] a, input[3 : 0] sel, output out);

  wire a_p, b_p;

  eight_mux muxa(
    .a (a[7 : 0]),
    .sel (sel[2 : 0]),
    .out (a_p)
  );

  eight_mux muxb(
    .a (a[15 : 8]),
    .sel (sel[2 : 0]),
    .out (b_p)
  );

  two_mux mux(
    .a (b_p),
    .b (a_p),
    .sel (sel[3]),
    .out (out)
  );
endmodule

module eight_mux(input[7 : 0] a, input[2 : 0] sel, output out);

  wire a_p, b_p;

  four_mux muxa(
    .a (a[3 : 0]),
    .sel (sel[1 : 0]),
    .out (a_p)
  );

  four_mux muxb(
    .a (a[7 : 4]),
    .sel (sel[1 : 0]),
    .out (b_p)
  );

  two_mux mux(
    .a (b_p),
    .b (a_p),
    .sel (sel[2]),
    .out (out)
  );
endmodule

module four_mux(input[3 : 0] a, input[1 : 0] sel, output out);

  wire a_p, b_p;

  two_mux muxa(
    .a (a[1]),
    .b (a[0]),
    .sel (sel[0]),
    .out (a_p)
  );

  two_mux muxb(
    .a (a[3]),
    .b (a[2]),
    .sel (sel[0]),
    .out (b_p)
  );

  two_mux mux(
    .a (b_p),
    .b (a_p),
    .sel (sel[1]),
    .out (out)
  );
endmodule
