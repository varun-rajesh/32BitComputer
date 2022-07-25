# 32BitComputer
 
A 5 stage pipelined 32-bit RISC processor with a MIPS derived instruction set.

The processor has 32 general purpose registers with reigster $0 permanently set to 0 and register $31 reserved for jump-and-link instruction.

## Instructions

To turn assembly into machine code, compile the assembler.c:
 ```gcc assembler.c -o assembler```

And pass input assembly file and output machine code file to the executable:
 ```assembler assembly_instruction_input machine_code_output```
 
The output found in machine_code_output can be passed to the instruction declaration in testbench.v

| Category           | Instruction         | Example             | Meaning                                |
|--------------------|---------------------|---------------------|----------------------------------------|
| Arithmetic         | add                 | add $r1, $r2, $r3   | $r1 = $r2 + $r3                        |
| Arithmetic         | add immediate       | addi, $r1, $r2, 20  | $r1 = $r2 + 20                         |
| Arithmetic         | subtract            | sub $r1, $r2, $r3   | $r1 = $r2 - $r3                        |
| Arithmetic         | subtract immediate  | subi $r1, $r2, 20   | $r1 = $r2 - 20                         |
| Arithmetic         | multiply            | mlt $r1, $r2, $r3   | {$r1, $low} = $r2 * $r3                |
| Arithmetic         | multiply immediate  | mlti $r1, $r2, 20   | {$r1, $low} = $r2 * 20                 |
| Arithmetic         | divide              | div $r1, $r2, $r3   | $r1 = ($r2 - $low) / $r3               |
| Arithmetic         | divide immediate    | divi $r1, $r2, 20   | $r1 = ($r2 - $low) / 20                |
| Logical            | and                 | and $r1, $r2, $r3   | $r1 = $r2 & $r3                        |
| Logical            | and immediate       | andi $r1, $r2, 20   | $r1 = $r2 & 20                         |
| Logical            | or                  | or $r1, $r2, $r3    | $r1 = $r2 \| $r3                       |
| Logical            | or immediate        | ori $r1, $r2, 20    | $r1 = $r2 \| 20                        |
| Logical            | shift right         | lsr $r1, $r2, 20    | $r1 = $r2 << 20                        |
| Logical            | shift left          | lsl $r1, $r2, 20    | $r1 = $r2 >> 20                        |
| Data transfer      | load word           | lw $r1, $r2, 20     | $r1 = Memory[$r2 + 20]                 |
| Data transfer      | store word          | sw $r1, $r2, 20     | Memory[$r2 + 20] = $r1                 |
| Data transfer      | move lo             | mvl $r1             | $r1 = $low                             |
| Conditional branch | branch on equal     | beq $r1, $r2, 20    | if ($r1 == $r2) goto PC + 4 + (4 * 20) |
| Conditional branch | branch on not equal | bne $r1, $r2, 20    | if ($r1 != $r2) goto PC + 4 + (4 * 20) |
| Conditional branch   | set on less than           | slt $r1, $r2, $r3   | if ($r1 < $r2) $r3 = 1                 |
| Conditional branch   | set on less than immediate | slti $r1, $r2, 20   | if ($r1 < 20) $r3 = 1                  |
| Unconditional branch | jump                       | j 2500              | goto 10000                             |
| Unconditional branch | jump to reg                | jr $r1              | goto $r1                               |
| Unconditional branch | jump and link              | jal 2500           | $31 = PC + 4; go to 10000  

