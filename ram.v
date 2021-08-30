module ram(input clk, read_enable, write_enable, input[31 : 0] address, data_in, output reg[31 : 0] data_out);
  reg[2097151 : 0] ram;

  always @ (negedge clk) begin
    data_out <= (read_enable) ? ram[{address[17 : 2], 2'b0} +: 32] : 32'bZ;
  end

  always @ (negedge clk) begin
    ram[{address[17 : 2], 2'b0} +: 32] <= (write_enable) ? data_in : ram[{address[17 : 2], 2'b0} +: 32];
  end
endmodule
