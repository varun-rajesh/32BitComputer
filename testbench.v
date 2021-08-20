`timescale 1 ns/1 ns
`include "adder.v"
`include "mux.v"
`include "subtracter.v"
`include "shifter.v"
`include "counter.v"
`include "registers.v"
`include "multiplier.v"
`include "divider.v"
`include "ram.v"
`include "computer.v"
`include "all_registers.v"
`include "alu.v"

module testbench;

  reg clk, reset;
  reg[1023 : 0] code;
  initial begin
    $dumpfile("testbench.vcd");
    $dumpvars;

    //in = 64'hf3002e4;
    code = {32'h09123898, 32'h109adf12, 32'h21439802, 32'hda129586, 32'h01892fe7, 32'h04792930};
    clk = 0;
    reset = 0;

    #10 reset = 1;
    #5000 reset = 0;

    #5 $finish;
  end

  always begin
    #5 clk = !clk;
  end

  computer computer(clk, reset, code);
endmodule
