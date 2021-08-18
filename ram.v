module ram(input clk, read_enable, write_enable, input[31 : 0] address, input[7 : 0] data_in, output reg[7 : 0] data_out);
  reg[7 : 0] ram[262143 : 0];

  always @ (negedge clk) begin
    data_out <= (read_enable) ? ram[address] : 8'bZZZZZZZZ;
  end

  always @ (negedge clk) begin
    ram[address[17 : 0]] <= (write_enable) ? data_in : ram[address[17 : 0]];
  end
endmodule
