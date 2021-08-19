module computer(input clk, reset, input[1023 : 0] code);

  wire pc_src, ifid_enable_in, branch_equal;
  wire[31 : 0] pc_in, pc_out, pc_next, instruction, ifid_pc_next, ifid_instruction,
  sign_extended_address, sign_extended_address_shifted, ar_out_a, ar_out_b,
  idex_instruction, idex_reg_a, idex_reg_b, idex_immediate;

  assign pc_src = 1'b1;
  assign pc_in = (pc_src) ? pc_next : sign_extended_address_shifted;

  word_register program_counter(
    .clk (clk),
    .enable_in (1'b1),
    .enable_out (1'b1),
    .reset (reset),
    .data (pc_in),
    .out (pc_out)
  );

  add add(
    .a (pc_out),
    .b (32'b100),
    .c_in (1'b0),
    .c (pc_next),
    .overflow ()
  );

  assign instruction = code[{pc_out, 3'b0} +: 5'b11111];

  word_register ifid_pc(
    .clk (clk),
    .enable_in (ifid_enable_in),
    .enable_out (1'b1),
    .reset (reset),
    .data (pc_next),
    .out (ifid_pc_next)
  );

  word_register ifid_i(
    .clk (clk),
    .enable_in (ifid_enable_in),
    .enable_out (1'b1),
    .reset (reset),
    .data (instruction),
    .out (ifid_instruction)
  );

  assign sign_extended_address = (ifid_instruction[15]) ? {16'hffff, ifid_instruction[15 : 0]} : {16'b0, ifid_instruction[15 : 0]};
  assign sign_extended_address_shifted = {sign_extended_address[29 : 0], 2'b00};

  add address(
    .a (sign_extended_address_shifted),
    .b (ifid_pc_next)
  );

  all_registers ar(
    .clk (clk),
    .reset (reset),
    .read_a (ifid_instruction[25 : 21]),
    .read_b (ifid_instruction[20 : 14]),
    .write_select (),
    .write_in (),
    .out_a (ar_out_a),
    .out_b (ar_out_b)
  );

  assign branch_equal = (ar_out_a == ar_out_b);

  word_register idex_i(
    .clk (clk),
    .enable_in (1'b1),
    .enable_out (1'b1),
    .reset (reset),
    .data (ifid_instruction),
    .out (idex_instruction)
  );

  word_register idex_reg_a(
    .clk (clk),
    .enable_in (1'b1),
    .enable_out (1'b1),
    .reset (reset),
    .data (ar_out_a),
    .out (idex_reg_a)
  );

  word_register idex_reg_b(
    .clk (clk),
    .enable_in (1'b1),
    .enable_out (1'b1),
    .reset (reset),
    .data (ar_out_b),
    .out (idex_reg_b)
  );

  word_register idex_immediate(
    .clk (clk),
    .enable_in (1'b1),
    .enable_out (1'b1),
    .reset (reset),
    .data (sign_extended_address),
    .out (idex_immediate)
  );

endmodule
