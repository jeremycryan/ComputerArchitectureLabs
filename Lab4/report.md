# Lab 3 Report
For this lab, we designed and implemented a pipeline CPU based on the single-cycle CPU we made for Lab 3. It has the same instruction set, with some changes to timing to account for the pipeline structure.

## Instructions and Timing
Our instruction set consists of the MIPS assembly commands listed below.

| Instruction | # Cycles | Description |
| ----------- | -------- | ----------- |
| ADDI | 1 | Adds a register value to a 16-bit immediate. |
| ADD | 1 | Adds two register values. |
| SUB | 1 | Subtracts two register values. |
| XORI | 1 | Perform a bitwise XOR on a register and a 16-bit immediate. |
| XOR | 1 | Perform a bitwise XOR on two register values. |
| SLT | 1 | Sets the output true if the second of two register values is strictly lesser. |
| J | 3 | Jumps to an instruction number. |
| JR | 3 | Jumps to an instruction number stored in a register. |
| JL | 3 | Jumps to an instruction stored in a register, and stores the program counter value. |
| BEQ | 3* | Branches if two register values are equal. Takes one cycle if branch not taken. |
| BNE | 3* | Branches if two register values are not equal. Takes one cycle if branch not taken. |
| SW | 1 | Stores a register value to data memory. |
| LW | 2* | Loads a value from data memory. Only takes two cycles if value is accessed immediately. |
