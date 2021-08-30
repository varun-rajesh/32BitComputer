# 32BitComputer
 
A 5 stage pipelined 32-bit RISC processor with a MIPS derived instruction set. Has 30 general purpose registers (registers 1 - 30) with register 0 hardcoded to 32'b0 and register 31 saved for jump and link instruction return value.

## Instruction Set

All instructions are 32 bits in length
Add: 6'b0, rs (5), rt (5), rd (5), 5'b0, 6'b1; rd <= rs + rt;
Add immediate: 6'b1, rs (5), rt(5), immediate (16); rt <= rs + immediate;

