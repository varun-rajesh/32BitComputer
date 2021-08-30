module alu(input clk, reset, input[5 : 0] funct, input[31 : 0] a, b, input[4 : 0] shamt, output reg[31 : 0] c, wire[31 : 0] c_low, output reg ready);

  wire multiply_ready, divide_ready;
  wire overflow;
  wire[31 : 0] add_c, sub_c, divide_q, divide_r, shift_l_c, shift_r_c;
  reg[31 : 0] temp_c_low;
  reg low_in;
  wire[63 : 0] multiply_c;

  always @ * begin
    case (funct)
      5'b00001: c = add_c;
      5'b01010: c = add_c;
      5'b01001: c = add_c;
      5'b00010: c = sub_c;
      5'b00101: c = a & b;
      5'b00110: c = a | b;
      5'b00111: c = shift_l_c;
      5'b01000: c = shift_r_c;
      5'b00011: c = multiply_c[63 : 32];
      5'b00100: c = divide_q;
      5'b01110: c = {31'b0, overflow};
      default: c = 32'b0;
    endcase
  end

  always @ * begin
    case (funct)
      5'b00011: temp_c_low = multiply_c[31 : 0];
      5'b00100: temp_c_low = divide_r;
      default: temp_c_low = 32'b0;
    endcase
  end

  always @ * begin
    case (funct)
      5'b00011: low_in = 1'b1;
      5'b00100: low_in = 1'b1;
      default: low_in = 1'b0;
    endcase
  end

  always @ * begin
    case(funct)
      5'b00011: ready = multiply_ready;
      5'b00100: ready = divide_ready;
      default: ready = 1'b1;
    endcase
  end

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
    .overflow (overflow)
  );

  multiply_unsigned multiply(
    .clk (clk),
    .reset (reset ? (multiply_ready ? 1'b1 : !ready) : 1'b0),
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

  shift_left sl(
    .in (a),
    .shift (shamt),
    .out (shift_l_c)
  );

  shift_right_signed sr(
    .in (a),
    .shift (shamt),
    .out (shift_r_c)
  );

  word_register c_low_register(
    .clk (clk),
    .enable_in (low_in),
    .enable_out (1'b1),
    .reset (reset),
    .data (temp_c_low),
    .out (c_low)
  );

endmodule
