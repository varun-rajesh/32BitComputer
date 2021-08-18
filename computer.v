module computer(input clk, reset, input[1023 : 0] code);

  wire pc_src, ifid_enable_in;
  wire[31 : 0] pc_in, pc_out, pc_next, instruction, ifid_pc_next, ifid_instruction, sign_extended_address, sign_extended_address_shifted;

  assign pc_src = 1'b1;
  assign pc_in = (pc_src) ? pc_next : sign;

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

  word_register ifid_instruction(
    .clk (clk),
    .enable_in (ifid_enable_in),
    .enable_out (1'b1),
    .reset (reset),
    .data (instruction),
    .out (ifid_instruction)
  );

  assign sign_extended_address = (instruction[15]) ? {16'hffff, instruction[15 : 0]} : {16'b0, instruction[15 : 0]};
  assign sign_extended_address_shifted = {sign_extended_address[29 : 0], 2'b00};

endmodule
