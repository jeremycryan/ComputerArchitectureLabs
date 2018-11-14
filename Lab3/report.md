# Lab 3 Report
For this lab we designed and implimented a single cycle CPU in verilog using the MIPS instruction set. It can perform LW, SW, J, JR, JL, BEQ, BNE, XORI, ADDI, ADD, SUB, and SLT


## Block Diagram

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

## Work Plan Reflection
