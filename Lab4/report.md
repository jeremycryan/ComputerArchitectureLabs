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

#### Control Flow Consistency
You might notice a few things that are pretty different about our pipeline design. First of all, all of our control flow commands are pretty slow. Because equalities for our branch logic are calculated during the execute phase, we decided to simplify from a design standpoint by making all of our control signals come from that phase. This means that all jump statements, even those that could be reduced to one or two cycles with custom hardware, occupy three cycles in the pipeline.

#### Really Bad Branch Prediction
Our branch instructions always assume the branch is not taken. This allows us to load instructions into the pipeline as normal, without having to interpret the branch until the execute phase. At this point, if the branch is taken, we convert the two instructions already loaded into the pipeline to null instructions.

This could be optimized with better branch prediction. Because programs tend to have a lot of loops, assuming a branch is taken will statistically safe more time on average than assuming a branch is not taken.

#### Selective Stalling on Load
The other big potential conflict we receive is from the LW command. Because we don't know the value of the word in data memory until the MEM phase, we're unable to forward it in time if the next instruction requires it during the ID phase. Rather than stall in all cases, and have the LW command take 2 cycles every time, we used some combinational logic to stall the pipeline only if the instruction immediately following LW tries to read from the same register.

## Phase Overview
We split our data path into five phases:

| Phase | Abbrev. | Description |
| -------- | -------- | -------- |
| Instruction Fetch | IF | Maintains a program counter and loads instructions from instruction memory. |
| Instruction Decode | ID | Parses the instruction into control signals and loads register values. |
| Execution | EX | Performs calculations and generates control flow signals. |
| Memory | MEM | Reads and writes to data memory. |
| Register Write | WR | Writes ALU results or memory loads to the register file. |

#### Pipeline Timing
Except for in special cases, each instruction spends one clock cycle in each phase. Thus, each instruction actually spends five or more cycles in the pipeline, even it is nominally "one cycle wide" as described in the instruction set table earlier.

Each phase is separated by a group of positive edge-triggered D flip-flops that hold the state of control and data signals. This means that signals propogate through the pipeline with the corresponding data, going through one register each positive edge of the clock.

## Testing
#### Fibonacci Test
To test a non-arbitrary program, we compiled an assembly test that computed the 8th digit of the fibonacci sequence with the first and second digit initalized. The assembly and gtkwave can be seen below. This was the first program we tested on our cpu. While there were no design errors with our cpu that this test caught, we did have to increase the clock period in order to give the ALU more time to settle on a value. This test used the following instructions: ADDI, ADD, BEQ, and J. This test demonstrates the stalling and flushing caused by BEQ.


![](https://github.com/jeremycryan/ComputerArchitectureLabs/blob/master/Lab4/fib_test_assembly.png)
![](https://github.com/jeremycryan/ComputerArchitectureLabs/blob/master/Lab4/fib_test_gtkwave.PNG)
#### Jump Test Program
This program was meant to test the various jump instructions within our instruction set. It revelealed that some of our flags related to these instructions were designed incorrectly. However, these errors were easy to fix. This program used the following instrucitons: ADDI, XORI, BNE, J, JL, and JR. This test demonstrates the stalling and flushing caused by BNE.


![](https://github.com/jeremycryan/ComputerArchitectureLabs/blob/master/Lab4/jump_test_program_assembly.PNG)
![](https://github.com/jeremycryan/ComputerArchitectureLabs/blob/master/Lab4/jump_test_program.PNG)
#### Test Program 1
This program was meant to test all the instructions the previous tests did not. It tested the following instructions: XORI, SUB, SLT, SW, and LW. It specifically tests the stalling caused by LW.


![](https://github.com/jeremycryan/ComputerArchitectureLabs/blob/master/Lab4/test_program_assembly.PNG)
![](https://github.com/jeremycryan/ComputerArchitectureLabs/blob/master/Lab4/test_program_gtkwave.PNG)

## Areas For Improvement

- The speed could be improved by adding hardware to detect and act on jumps earlier in the pipeline.
- The execution time of branch statements could be further reduced with more intelligent branch prediction.
- There are several places where hardware use could be reduced. For instance, we have extra registers that hold control signals later in the pipeline than they are used.
- The instruction set is still a pretty small subset of MIPS, and could be expanded.

