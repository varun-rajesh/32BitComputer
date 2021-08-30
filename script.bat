vlog testbench.v
vsim -c -do "run -all" testbench
gtkwave testbench.vcd
