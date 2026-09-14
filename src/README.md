# Tiny 7-bit CPU

A compact educational CPU based on the uploaded multi-module design.

## Widths
- Datapath/register width: 7 bits
- Registers: 8 x 7-bit
- Instructions: 16 bits
- Instruction memory: 32 x 16-bit
- Data memory: 8 x 7-bit
- PC: 5 bits

## ISA
| Opcode | Instruction |
|---|---|
| 0 | ADD |
| 1 | SUB |
| 2 | AND |
| 3 | OR |
| 4 | XOR |
| 5 | SLL |
| 6 | SRL |
| 7 | ADDI |
| 8 | LOAD |
| 9 | STORE |
| A | BEQ |
| B | JMP |

R0 is hard-wired to zero.

PC is instruction-indexed, so normal execution increments PC by 1.

For STORE, rs1 is the base address register, rs2 is the data register, and imm[5:0] is the signed offset. The data memory uses the low 3 address bits.

The design is intentionally small and suitable as an educational Tiny Tapeout-style CPU. Synthesis area should be measured with the actual target PDK; RTL bit counts alone do not predict final silicon area exactly.
