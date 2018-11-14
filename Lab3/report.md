# Lab 3 Report
For this lab we designed and implimented a single cycle CPU in verilog using the MIPS instruction set. It can perform LW, SW, J, JR, JL, BEQ, BNE, XORI, ADDI, ADD, SUB, and SLT.


## Block Diagram
![](https://github.com/jeremycryan/ComputerArchitectureLabs/blob/master/Lab3/cpu_block_diagram.PNG)

Shown above is our block diagram CPU. We split it up into four components:

- The **instruction fetch unit** maintains the program counter and handles jumps and branches. It takes several control lines, as shown above, from the instruction decoder and data path, and outputs an instruction address to the instruction memory.
- The **instruction memory** is the actual memory unit that holds the assembly program in a series of registers. It takes in an address and outputs a 32-bit instruction.
- The **instruction decoder** uses this 32-bit instruction to generate a number of control signals which feed back to the instruction fetch unit and forward to the data path. An example is `ALUcntrl`, which chooses the function to use for the ALU.
- The **data path** contains most of the actual computation of the unit. It contains a register file, ALU, and data memory, and executes all non-jump, non-branch commands based on the control signals given by the instruction decoder.

## Testing
### Fibonacci Test
To test a non-arbitrary program, we compiled an assembly test that computed the 8th digit of the fibonacci sequence with the first and second digit initalized. The assembly and gtkwave can be seen below. This was the first program we tested on our cpu. While there were no design errors with our cpu that this test caught, we did have to increase the clock period in order to give the ALU more time to settle on a value. This test used the following instructions: ADDI, ADD, BEQ, and J.


![](https://github.com/jeremycryan/ComputerArchitectureLabs/blob/master/Lab3/fib_test_assembly.png)
![](https://github.com/jeremycryan/ComputerArchitectureLabs/blob/master/Lab3/fib_test_gtkwave.PNG)
### Jump Test Program
This program was meant to test the various jump instructions within our instruction set. It revelealed that some of our flags related to these instructions were designed incorrectly. However, these errors were easy to fix. This program used the following instrucitons: ADDI, XORI, BNE, J, JL, and JR.


![](https://github.com/jeremycryan/ComputerArchitectureLabs/blob/master/Lab3/jump_test_program_assembly.PNG)
![](https://github.com/jeremycryan/ComputerArchitectureLabs/blob/master/Lab3/jump_test_program.PNG)
### Test Program 1
This program was meant to test all the instructions the previous tests did not. It tested the following instructions: XORI, SUB, SLT, SW, and LW.


![](https://github.com/jeremycryan/ComputerArchitectureLabs/blob/master/Lab3/test_program_assembly.PNG)
![](https://github.com/jeremycryan/ComputerArchitectureLabs/blob/master/Lab3/test_program_gtkwave.PNG)

## Performance/Area Analysis
![](https://github.com/jeremycryan/ComputerArchitectureLabs/blob/master/Lab3/ifu_block_diagram.PNG)

Component | Cost | # of | Total Cost
----------|------|------|-----------
32bit Mux | 3,520|  4   |   14,080
Adder     | 6,080|   1  |   6,080
AND Gate  |  30  |  1   |   30
XOR Gate  |  50  | 1    |   50
Registers |  130 |  32  |   4,160

Total Cost: 24,400

We calculated area of our instruction fetch unit as ten times the number of "gate input equivalents." Our design, shown above as a block diagram, was fairly simple, but could benefit from a few optimizations (for instance, moving the sign extender after the branch multiplexer, halving its inputs). 

As our design developed, we found ourselves adding more multiplexers into our instruction fetch unit to add more functionality; this worked well, but there may exist further logical optimizations we could apply to cut down on area use.
