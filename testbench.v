`timescale 1 ns/1 ns
`include "mux.v"
`include "shifters.v"
`include "registers.v"
`include "all_registers.v"
`include "computer.v"
`include "alu.v"
`include "adder.v"
`include "divider.v"
`include "subtracter.v"
`include "multiplier.v"
`include "ram.v"

module testbench;
  reg clk, reset;
  reg[65535 : 0] code;

  initial begin
    $dumpfile("testbench.vcd");
    $dumpvars;

    clk = 1'b0;
    reset = 1'b0;
    code = {32'h0422af43, 32'h2401000f};
    #10 reset = 1'b1;

    #500 reset = 1'b0;

    #10 $finish;
  end

  always begin
    #5 clk = !clk;
  end

  computer c(clk, reset, code);
endmodule
