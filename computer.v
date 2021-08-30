module computer(input clk, reset, input[65535 : 0] code);

  //INSTRUCTION FETCH
  //DATA
  wire[31 : 0] program_counter_in, program_counter_out, program_counter_incremented;
  wire[31 : 0] branch_address;
  wire[31 : 0] jump_register_value;
  wire[31 : 0] jump_immediate_address;
  wire[31 : 0] current_instruction;

  //CONTROL
  wire[1 : 0] control_program_counter_select;

  //HAZARD
  wire hazard_program_counter_write;
  wire hazard_ifid_write_enable;

  //INSTRUCTION DECODE
  //DATA
  wire[31 : 0] ifid_program_counter_incremented, ifid_current_instruction;
  wire[31 : 0] sign_extended_immediate;
  wire[31 : 0] registers_a, registers_b;

  //CONTROL
  wire control_destination_register_select; //1 for rd, 0 for rt
  wire control_alu_source_select; //1 for register, 0 for immediate
  wire control_memory_read_enable, control_memory_write_enable; //1 for enable, 0 for disable
  wire[1 : 0] control_write_back_register_select;
  wire control_registers_write_enable;
  reg[1 : 0] jump_register_select;
  wire registers_equal;

  //HAZARD
  wire hazard_detect, exmem_hazard_detect;
  wire hazard_idex_ifid_flush;

  //EXECUTION
  //DATA
  wire[31 : 0] idex_registers_a, idex_registers_b;
  wire[31 : 0] idex_sign_extended_immediate;
  wire[31 : 0] idex_current_instruction_temp, idex_current_instruction;
  wire[4 : 0] destination_register;
  wire[31 : 0] alu_a_in, alu_b_in_temp, alu_b_in;
  wire[31 : 0] alu_c, alu_c_low;

  //CONTROL
  wire[5 : 0] exmem_opcode;
  wire control_idex_destination_register_select;
  wire control_idex_alu_source_select;
  wire control_idex_registers_write_enable;
  wire control_idex_memory_read, control_idex_memory_write;
  wire[1 : 0] control_idex_write_back_register_select;
  reg[1 : 0] forward_alu_a_select, forward_alu_b_select;
  wire alu_ready;

  //HAZARD
  wire hazard_idex_write_enable, hazard_exmem_write_enable;

  //MEMORY
  //DATA
  wire[31 : 0] exmem_alu_c, exmem_alu_c_low;
  wire exmem_alu_ready;
  wire[31 : 0] exmem_immediate;
  wire[4 : 0] exmem_destination_register;
  wire[31 : 0] mem_out;

  //CONTROL
  wire control_exmem_registers_write_enable, control_exmem_memory_read, control_exmem_memory_write;
  wire[1 : 0] control_exmem_write_back_register_select;

  //WRITE BACK
  //DATA
  wire[31 : 0] memwb_mem_out, memwb_alu_c, memwb_alu_c_low;
  wire[4 : 0] memwb_destination_register;
  wire[31 : 0] selected_write_back_value;

  //CONTROl
  wire[1 : 0] control_memwb_write_back_register_select;
  wire control_memwb_registers_write_enable;
  wire[1 : 0] control_idex_program_counter_select;

  //INSTRUCTION FETCH
  assign hazard_ifid_write_enable = hazard_detect ? 1'b0 : alu_ready;
  assign hazard_program_counter_write = hazard_detect ? 1'b0 : alu_ready;
  assign hazard_idex_ifid_flush = (control_idex_program_counter_select != 2'b0);


  //JUMP REGISTER SELECT
  always @ * begin
    if(control_exmem_registers_write_enable & exmem_destination_register == ifid_current_instruction[25 : 21] & exmem_destination_register != 5'b0) jump_register_select <= 2'b11;
    else if (control_memwb_registers_write_enable & memwb_destination_register == idex_current_instruction[25 : 21] & memwb_destination_register != 5'b0) jump_register_select <= 2'b1;
    else jump_register_select <= 2'b0;
  end

  four_input_word_mux jump_register_selector(
    .a ({exmem_alu_c, exmem_alu_c_low, selected_write_back_value, registers_a}),
    .sel (jump_register_select),
    .out (jump_register_value)
  );

  four_input_word_mux program_counter_selector(
    .a ({branch_address, jump_register_value, jump_immediate_address, program_counter_incremented}),
    .sel (control_program_counter_select),
    .out (program_counter_in)
  );

  word_register program_counter_register(
    .clk (clk),
    .enable_in (hazard_program_counter_write),
    .enable_out (1'b1),
    .reset (reset),
    .data (program_counter_in),
    .out (program_counter_out)
  );

  add program_counter_incrementer(
    .a (program_counter_out),
    .b (32'b100),
    .c_in (1'b0),
    .c (program_counter_incremented),
    .overflow ()
  );

  assign current_instruction = code[{program_counter_out,3'b0} +: 32];

  sb_register ifid[63 : 0](
    .clk (clk),
    .enable_in (hazard_ifid_write_enable),
    .enable_out (1'b1),
    .reset (reset ? !hazard_idex_ifid_flush : reset),
    .data ({
      program_counter_incremented,
      current_instruction
    }),
    .out ({
      ifid_program_counter_incremented,
      ifid_current_instruction})
  );

  //INSTRUCTION DECODE
  add branch_address_adder(
    .a (ifid_program_counter_incremented),
    .b (sign_extended_immediate),
    .c_in (1'b0),
    .c (branch_address),
    .overflow ()
  );

  all_registers registers(
    .clk (clk),
    .reset (reset),
    .pc_write (ifid_current_instruction[31 : 26] == 6'b010001),
    .read_a (ifid_current_instruction[25 : 21]),
    .read_b (ifid_current_instruction[20 : 16]),
    .write_sel ({control_memwb_registers_write_enable, memwb_destination_register}),
    .data_in(selected_write_back_value),
    .program_counter(ifid_program_counter_incremented),
    .out_a (registers_a),
    .out_b (registers_b)
  );

  //INSTRUCTION DECODE STAGE
  assign hazard_idex_write_enable = hazard_detect ? 1'b0 : alu_ready;

  assign sign_extended_immediate = {(ifid_current_instruction[15]) ? 16'hffff : 16'h0, ifid_current_instruction[15 : 0]};

  assign jump_immediate_address = {ifid_program_counter_incremented[31 : 30], ifid_current_instruction[25 : 0], 2'b0};

  assign registers_equal = registers_a == registers_b;

  //ALU IMMEDIATE OR REG B
  assign control_alu_source_select = ifid_current_instruction[31 : 26] == 6'b0;

  //DESTINATION RT OR RD
  assign control_destination_register_select = ifid_current_instruction[31 : 26] == 6'b0;

  //DETERMINE BRANCH TYPE
  assign control_program_counter_select = (registers_equal & (ifid_current_instruction[31 : 26] == 6'b1100)) | (!registers_equal & (ifid_current_instruction[31 : 26] == 6'b1101)) ? 2'b11 : (ifid_current_instruction[31 : 26] == 6'b1111) ? 2'b10 : (ifid_current_instruction[31 : 26] == 6'b10000 | ifid_current_instruction[31 : 26] == 6'b10001) ? 2'b1 : 2'b0;

  assign control_registers_write_enable = (hazard_detect) ? 1'b1 : ifid_current_instruction[31 : 26] == 6'b1010 | ifid_current_instruction[31 : 26] == 6'b1100 | ifid_current_instruction[31 : 26] == 6'b1101 | ifid_current_instruction[31 : 26] == 6'b1111 | ifid_current_instruction[31 : 26] == 6'b10000 | ifid_current_instruction[31 : 26] == 6'b10001;

  assign control_memory_read = (hazard_detect) ? 1'b0 : (ifid_current_instruction[31 : 26] == 6'b1001);

  assign control_memory_write = (hazard_detect) ? 1'b0 : (ifid_current_instruction[31 : 26] == 6'b1010);

  assign control_write_back_register_select = (ifid_current_instruction[31 : 26] == 6'b1001) ? 2'b11 :
    (ifid_current_instruction[31 : 26] == 6'b0) | (ifid_current_instruction[31 : 26] == 6'b1) | (ifid_current_instruction[31 : 26] == 6'b10) | (ifid_current_instruction[31 : 26] == 6'b11) | (ifid_current_instruction[31 : 26] == 6'b100) | (ifid_current_instruction[31 : 26] == 6'b101) | (ifid_current_instruction[31 : 26] == 6'b110) ? 2'b10 : (ifid_current_instruction[31 : 26] == 6'b1011) ? 2'b1 : 2'b0;

  //CHECK IF LOAD WORD HAZARD OCCURS
  assign hazard_detect = (idex_current_instruction[31 : 26] == 6'b1001)
  & (ifid_current_instruction[25 : 21] == destination_register | (ifid_current_instruction[31 : 26] == 6'b0 & ifid_current_instruction[20 : 16] == destination_register));

  sb_register idex[136 : 0](
    .clk (clk),
    .enable_in (hazard_idex_write_enable),
    .enable_out (1'b1),
    .reset (reset),
    .data ({
      control_alu_source_select,
      control_destination_register_select,
      control_registers_write_enable,
      control_memory_read,
      control_memory_write,
      control_program_counter_select,
      control_write_back_register_select,
      registers_a,
      registers_b,
      sign_extended_immediate,
      ifid_current_instruction
    }),
    .out  ({
      control_idex_alu_source_select,
      control_idex_destination_register_select,
      control_idex_registers_write_enable,
      control_idex_memory_read,
      control_idex_memory_write,
      control_idex_program_counter_select,
      control_idex_write_back_register_select,
      idex_registers_a,
      idex_registers_b,
      idex_sign_extended_immediate,
      idex_current_instruction_temp})
  );

  //EXECUTION
  assign hazard_exmem_write_enable = alu_ready;
  assign destination_register = (control_idex_destination_register_select) ? idex_current_instruction[15 : 11] : idex_current_instruction[20 : 16];
  assign idex_current_instruction = (exmem_hazard_detect) ? 32'b0 : idex_current_instruction_temp;

  //ALU_A FORWARDING
  always @ * begin
    if (control_exmem_registers_write_enable & exmem_destination_register == idex_current_instruction[25 : 21] & exmem_destination_register != 5'b0)  forward_alu_a_select <= (exmem_opcode == 6'b1011) ? 2'b01 : 2'b10;
    else if (control_memwb_registers_write_enable & memwb_destination_register == idex_current_instruction[25 : 21] & memwb_destination_register != 5'b0) forward_alu_a_select <= 2'b11;
    else forward_alu_a_select <= 2'b00;
  end

  //ALU_B FORWARDING
  always @ * begin
    if (idex_current_instruction[31 : 26] == 6'b0 | idex_current_instruction[31 : 26] == 6'b1010) begin
      if (control_exmem_registers_write_enable & exmem_destination_register == idex_current_instruction[20 : 16] & exmem_destination_register != 5'b0) forward_alu_b_select <= (exmem_opcode == 6'b1011) ? 2'b01 : 2'b10;
      else if (control_memwb_registers_write_enable & memwb_destination_register == idex_current_instruction[20 : 16] & memwb_destination_register != 5'b0) forward_alu_b_select <= 2'b11;
      else forward_alu_b_select <= 2'b00;
    end else begin
      forward_alu_b_select <= 2'b00;
    end
  end

  four_input_word_mux alu_a_mux(
    .a ({selected_write_back_value, exmem_alu_c, exmem_alu_c_low, idex_registers_a}),
    .sel (forward_alu_a_select),
    .out (alu_a_in)
  );

  four_input_word_mux alu_b_mux(
    .a ({selected_write_back_value, exmem_alu_c, exmem_alu_c_low, idex_registers_b}),
    .sel (forward_alu_b_select),
    .out (alu_b_in_temp)
  );

  assign alu_b_in = (control_idex_alu_source_select) ? alu_b_in_temp : idex_sign_extended_immediate;

  alu alu(
    .clk (clk),
    .reset (reset),
    .funct ((idex_current_instruction[31 : 26] == 6'b0) ? idex_current_instruction[5 : 0] : idex_current_instruction[31 : 26]),
    .shamt (idex_current_instruction[10 : 6]),
    .a (alu_a_in),
    .b (alu_b_in),
    .c (alu_c),
    .c_low (alu_c_low),
    .ready (alu_ready)
  );

  sb_register exmem[113 : 0](
    .clk (clk),
    .enable_in (hazard_exmem_write_enable),
    .enable_out (1'b1),
    .reset (reset),
    .data ({
      control_idex_registers_write_enable,
      control_idex_memory_read,
      control_idex_memory_write,
      control_idex_write_back_register_select,
      idex_current_instruction[31 : 26],
      alu_c,
      alu_c_low,
      alu_ready,
      alu_b_in_temp,
      destination_register,
      hazard_detect
    }),
    .out ({
      control_exmem_registers_write_enable,
      control_exmem_memory_read,
      control_exmem_memory_write,
      control_exmem_write_back_register_select,
      exmem_opcode,
      exmem_alu_c,
      exmem_alu_c_low,
      exmem_alu_ready,
      exmem_immediate,
      exmem_destination_register,
      exmem_hazard_detect
    })
  );

  //MEMORY
  assign hazard_memwb_write_enable = alu_ready;

  ram ram(
    .clk (clk),
    .read_enable (control_exmem_memory_read),
    .write_enable (control_exmem_memory_write),
    .address (exmem_alu_c),
    .data_in (exmem_immediate),
    .data_out (mem_out)
  );

  sb_register memwb[103 : 0](
    .clk (clk),
    .enable_in (hazard_memwb_write_enable),
    .enable_out (1'b1),
    .reset (reset),
    .data ({
      control_exmem_registers_write_enable,
      control_exmem_write_back_register_select,
      mem_out,
      exmem_alu_c,
      exmem_alu_c_low,
      exmem_destination_register
    }),
    .out ({
      control_memwb_registers_write_enable,
      control_memwb_write_back_register_select,
      memwb_mem_out,
      memwb_alu_c,
      memwb_alu_c_low,
      memwb_destination_register
    })
  );

  //WRITE BACK
  four_input_word_mux write_back_value_select(
    .a ({memwb_mem_out, memwb_alu_c, memwb_alu_c_low, 32'b0}),
    .sel (control_memwb_write_back_register_select),
    .out (selected_write_back_value)
  );


endmodule
