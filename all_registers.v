module all_registers(input clk, reset, pc_write, input[4 : 0] read_a, read_b, input[5 : 0] write_sel, input[31 : 0] data_in, program_counter, output[31 : 0] out_a, out_b);

  parameter N = 32;
  genvar i;
  wire[31 : 0] temp_out_a, temp_out_b;

  generate
    for(i = 0; i < N; i = i + 1) begin
      word_two_out_register register(
        .clk (clk),
        .reset (reset),
        .enable_in ((i == 0) ? 1'b0 : (i == 6'b111111) ? pc_write : (i == write_sel)),
        .enable_out_a (i == read_a),
        .enable_out_b (i == read_b),
        .data ((i == 6'b111111) ? program_counter : data_in),
        .out_a (temp_out_a),
        .out_b (temp_out_b)
      );
    end
  endgenerate

  assign out_a = (read_a == write_sel[4 : 0] & write_sel[5] == 0) ? data_in : temp_out_a;
  assign out_b = (read_b == write_sel[4 : 0] & write_sel[5] == 0) ? data_in : temp_out_b;


endmodule
