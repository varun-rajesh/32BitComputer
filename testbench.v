`timescale 1 ns/1 ns
`include "adder.v"

module testbench;

  reg[31:0] a, b;
  wire[31:0] c;

  initial begin

    $dumpfile("testbench.vcd");
    $dumpvars;

    a = 32'h4a9a;
    b = 32'h11e3;

    #50
    a = 1;
    b = 0;

    #50
    a = 0;
    b = 1;

    #50 $finish;
  end

  add adder(a, b, c);

endmodule
