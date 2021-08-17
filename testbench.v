`timescale 1 ns/1 ns
`include "adder.v"
`include "mux.v"
`include "subtracter.v"

module testbench;

  reg[31:0] a, b;
  wire[31:0] c;
  wire overflow;

  initial begin

    $dumpfile("testbench.vcd");
    $dumpvars;

    b = 32'h1d834a9a;
    a = 32'h23fc11e3;

    #5000
    a = 1;
    b = 0;

    #5000
    a = 0;
    b = 1;

    #50 $finish;
  end

  subtract sub(a, b, c, overflow);

endmodule
