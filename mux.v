//mux selects by little endian
module four_input_bit_mux(input[3 : 0] a, input[1 : 0] sel, output out);
  assign out = a[sel];
endmodule

//mux selects by little endian
module four_input_word_mux(input[127 : 0] a, input[1 : 0] sel, output[31 : 0] out);
  assign out = a[{sel, 5'b0} +: 32];
endmodule
