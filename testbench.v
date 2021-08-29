`timescale 1 ns/1 ns
`include "mux.v"
`include "shifters.v"
`include "registers.v"
`include "all_registers.v"
`include "computer.v"
`include "alu.v"
`include "ram.v"
`include "multiplier.v"

module testbench;
  reg clk, reset, read_enable, write_enable;
  reg[31 : 0] address, data_in;
  wire[31 : 0] data_out;
  reg[65535 : 0] code;

  initial begin
    $dumpfile("testbench.vcd");
    $dumpvars;

    clk = 1'b0;
    reset = 1'b0;
    write_enable = 1'b1;
    read_enable = 1'b1;
    address = 32'hf203fe33;
    data_in = 32'h01010101;
    code = {32'h0422af43, 32'h2401000f};
    #10 reset = 1'b1;

    #500 reset = 1'b0;

    #10 $finish;
  end

  always begin
    #5 clk = !clk;
  end

  computer c(clk, reset, code);
  //sram ram(clk, read_enable, write_enable, address, data_in, data_out);
endmodule
