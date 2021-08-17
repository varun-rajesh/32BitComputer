module shift_left(input[31 : 0] in, input[4 : 0] shift, output[31 : 0] out);
  integer i, j;
  genvar k;
  parameter N = 32;
  reg[1023 : 0] choices;

  always @ * begin
    for(i = 0; i < N; i = i + 1) begin
      for(j = 0; j < N; j = j + 1) begin
        choices[{i[4 : 0], j[4 : 0]}] <= (j <= i) ? in[i - j] : 1'b0;
      end
    end
  end

  generate
    for(k = 0; k < N; k = k + 1) begin
      thirtytwo_mux mux(
        .a (choices[32 * k + 31 : 32 * k]),
        .sel (shift),
        .out (out[k])
      );
    end
  endgenerate
endmodule

module shift_right_signed(input[31 : 0] in, input[4 : 0] shift, output[31 : 0] out);
  integer i, j;
  genvar k;
  parameter N = 32;
  reg[1023 : 0] choices;
  reg[31 : 0] temp;

  always @ * begin
    for(i = 0; i < N; i = i + 1) begin
      for(j = 0; j < N; j = j + 1) begin
        choices[{i[4 : 0], j[4 : 0]}] <= (i + j < N) ? in[i + j] : in[31];
      end
    end
  end

  generate
    for(k = 0; k < N; k = k + 1) begin
      thirtytwo_mux mux(
        .a (choices[32 * k + 31 : 32 * k]),
        .sel (shift),
        .out (out[k])
      );
    end
  endgenerate
endmodule


module shift_right_unsigned(input[31 : 0] in, input[4 : 0] shift, output[31 : 0] out);
  integer i, j;
  genvar k;
  parameter N = 32;
  reg[1023 : 0] choices;
  reg[31 : 0] temp;

  always @ * begin
    for(i = 0; i < N; i = i + 1) begin
      for(j = 0; j < N; j = j + 1) begin
        choices[{i[4 : 0], j[4 : 0]}] <= (i + j < N) ? in[i + j] : 1'b0;
      end
    end
  end

  generate
    for(k = 0; k < N; k = k + 1) begin
      thirtytwo_mux mux(
        .a (choices[32 * k + 31 : 32 * k]),
        .sel (shift),
        .out (out[k])
      );
    end
  endgenerate
endmodule

module sixtyfour_shift_left(input[63 : 0] in, output[63 : 0] out);
  integer i;
  parameter N = 64;
  always @ * begin
    for(i = 0; i < N; i = i + 1) begin
      out[i] <  = (i != 0) ? in[i - 1] : 1'b0;
    end
  end
endmodule

module sixtyfour_shift_right_signed(input[63 : 0] in, output[63 : 0] out);
  integer i;
  parameter N = 64;
  always @ * begin
    for(i = 0; i < N; i = i + 1) begin
      out[i] <= (i != N - 1) ? in[i + 1] : in[63];
    end
  end
endmodule

module sixtyfour_shift_right_unsigned(input[63 : 0] in, output[63 : 0] out);
  integer i;
  parameter N = 64;
  always @ * begin
    for(i = 0; i < N; i = i + 1) begin
      out[i] <= (i != N - 1) ? in[i + 1] : 1'b0;
    end
  end
endmodule
