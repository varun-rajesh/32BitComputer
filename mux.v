module mux(input a, b, sel, output out);
  assign out = (sel & a) | (~sel & b);
endmodule

module word_mux(input[31 : 0] a, b, input sel, input[31 : 0] out);
  mux mux[31 : 0](
    .a (a),
    .b (b),
    .sel (sel),
    .out (out)
  );
endmodule
