module all_registers(input clk, input reset, input[5 : 0] read_a, read_b, write_select, input[31 : 0] write_in, output[31 : 0] out_a, out_b);

  parameter N = 32;
  genvar i;

  generate
    for(i = 0; i < N; i = i + 1) begin
      two_out_word_register register(
        .clk (clk),
        .reset (reset),
        .enable_in (i == write_select),
        .enable_out_a (i == read_a),
        .enable_out_b (i == read_b),
        .data (write_in),
        .out_a (out_a),
        .out_b (out_b)
      );
    end
  endgenerate

endmodule
