# Lab 2 Report

For this lab, we constructed a 32-bit ALU in structural Verilog from gate-level components. This module behaves 
differently depending on its 3-bit `select` line:

Select | Function
-------|---------
000    | Add
001    | Subtract
010    | Set less than
011    | Bitwise XOR
100    | Bitwise AND
101    | Bitwise NAND
110    | Bitwise NOR
111    | Bitwise OR

## Implementation

### One bit at a time

We decided to implement our ALU by first creating a 1-bit module, with *almost* all of the functionality of a full 
ALU. A block diagram is shown below.

![1-bit ALU block diagram](https://github.com/jeremycryan/ComputerArchitectureLabs/blob/master/Lab1/alu_1bit.jpg?raw=true)

It is worth noting that this 1-bit module **does not** calculate SLT -- if it receives a `select` input of 010, it always
outputs false. This is because we implemented SLT at the 32-bit level using the *subtract* functionality.

### Stringing the bits together

These 1-bit ALUs link together as shown in the diagram below. Each has access to the corresponding bit of the inputs A and B;
the `select` inputs S0, S1, and S2; and the carryout bit of the previous element. Only the *add* and *subtract* functions use
the carryout bit.

![Multi-bit ALU block diagram](https://github.com/jeremycryan/ComputerArchitectureLabs/blob/master/Lab1/alu_1bit_string.jpg?raw=true)

This 32-bit ALU additionally calculates the following outputs:

- **Zero**: This output is true if all output bits are zeros.
- **Carryout**: This output is true if the most significant 1-bit module had a bit carryout.
- **Overflow**: This output is true if the most significant and second-most significant carryout bits are not equal, indicating
that an overflow occurred.

Note that, at this point in the design, the ALU **still does not calculate SLT.** Everything defined before this point will
be referenced as the "Non-SLT ALU," and we will be adding additional modules to the inputs and outputs to add SLT functionality.

### Set less than functionality

When ideating about how to implement the SLT function, we determined that we could simply use the *subtract* mode, and then
test for negativity. This meant creating the following two modules:

- An **SLT Control** module which takes in the `select` sequence for the entire unit and, in the event of an SLT code, outputs
the sequence for *subtract* instead. Otherwise, it should output the unaltered code, in addition to a one-bit output that is true 
when the input is the SLT sequence.

- An **SLT-inator** module (only the most useful, descriptive module names for our project) that overwrites the outputs to the
whole system in the event of an SLT `select` code. If the result of the subtraction is positive, it outputs zero. If the result
is negative, it outputs one. We additionally invert this output in the event of an overflow, to counteract the "sign flip" that
occurs.

Our full, 32-bit ALU now looks as follows:

![High-level ALU block diagram](https://github.com/jeremycryan/ComputerArchitectureLabs/blob/master/Lab1/alu32.jpg?raw=true)

Note that there is some logic not shown that affects the carryout, overflow, and zero values based on the output of the SLT-inator
(for instance, in SLT mode, carryout and overflow are always false).

## Test Results

```
 ---------------A---------------- | ---------------B---------------- | SEL | --------------OUT--------------- | CO ZR OF
 Testing CarryOut of Subtraction without Overflows and Testing SLT with Positive Numbers
 00000000000000000010000000000001 | 00000000000000000000000000000001 | 000 | 00000000000000000010000000000010 |  0  0  0 
 00000000000000000010000000000001 | 00000000000000000000000000000001 | 001 | 00000000000000000010000000000000 |  1  0  0 
 00000000000000000010000000000001 | 00000000000000000000000000000001 | 010 | 00000000000000000000000000000000 |  0  1  0 
 00000000000000000010000000000001 | 00000000000000000000000000000001 | 011 | 00000000000000000010000000000000 |  0  0  0 
 00000000000000000010000000000001 | 00000000000000000000000000000001 | 100 | 00000000000000000000000000000001 |  0  0  0 
 00000000000000000010000000000001 | 00000000000000000000000000000001 | 101 | 11111111111111111111111111111110 |  0  0  0 
 00000000000000000010000000000001 | 00000000000000000000000000000001 | 110 | 11111111111111111101111111111110 |  0  0  0 
 00000000000000000010000000000001 | 00000000000000000000000000000001 | 111 | 00000000000000000010000000000001 |  0  0  0 
------------------------------------------------------------------------------------------------------------------------
Testing Overflows with Negative Numbers and Testing SLT with Negative Numbers
 10000000000000000000000000000000 | 10000000000000000000000000000001 | 000 | 00000000000000000000000000000001 |  1  0  1 
 10000000000000000000000000000000 | 10000000000000000000000000000001 | 001 | 11111111111111111111111111111111 |  0  0  0 
 10000000000000000000000000000000 | 10000000000000000000000000000001 | 010 | 00000000000000000000000000000001 |  0  0  0 
 10000000000000000000000000000000 | 10000000000000000000000000000001 | 011 | 00000000000000000000000000000001 |  0  0  0 
 10000000000000000000000000000000 | 10000000000000000000000000000001 | 100 | 10000000000000000000000000000000 |  0  0  0 
 10000000000000000000000000000000 | 10000000000000000000000000000001 | 101 | 01111111111111111111111111111111 |  0  0  0 
 10000000000000000000000000000000 | 10000000000000000000000000000001 | 110 | 01111111111111111111111111111110 |  0  0  0 
 10000000000000000000000000000000 | 10000000000000000000000000000001 | 111 | 10000000000000000000000000000001 |  0  0  0 
------------------------------------------------------------------------------------------------------------------------
Testing Overflow Panic Suppression of SLT
 00000000000000000010000000000001 | 10000000000000000000000000000001 | 000 | 10000000000000000010000000000010 |  0  0  0 
 00000000000000000010000000000001 | 10000000000000000000000000000001 | 001 | 10000000000000000010000000000000 |  0  0  1 
 00000000000000000010000000000001 | 10000000000000000000000000000001 | 010 | 00000000000000000000000000000000 |  0  1  0 
 00000000000000000010000000000001 | 10000000000000000000000000000001 | 011 | 10000000000000000010000000000000 |  0  0  0 
 00000000000000000010000000000001 | 10000000000000000000000000000001 | 100 | 00000000000000000000000000000001 |  0  0  0 
 00000000000000000010000000000001 | 10000000000000000000000000000001 | 101 | 11111111111111111111111111111110 |  0  0  0 
 00000000000000000010000000000001 | 10000000000000000000000000000001 | 110 | 01111111111111111101111111111110 |  0  0  0 
 00000000000000000010000000000001 | 10000000000000000000000000000001 | 111 | 10000000000000000010000000000001 |  0  0  0 
------------------------------------------------------------------------------------------------------------------------
Testing CarryOuts
 10000000000000000010000000000001 | 10000000000000000000000000000000 | 000 | 00000000000000000010000000000001 |  1  0  1 
 10000000000000000010000000000001 | 10000000000000000000000000000000 | 001 | 00000000000000000010000000000001 |  1  0  0 
 10000000000000000010000000000001 | 10000000000000000000000000000000 | 010 | 00000000000000000000000000000000 |  0  1  0 
 10000000000000000010000000000001 | 10000000000000000000000000000000 | 011 | 00000000000000000010000000000001 |  0  0  0 
 10000000000000000010000000000001 | 10000000000000000000000000000000 | 100 | 10000000000000000000000000000000 |  0  0  0 
 10000000000000000010000000000001 | 10000000000000000000000000000000 | 101 | 01111111111111111111111111111111 |  0  0  0 
 10000000000000000010000000000001 | 10000000000000000000000000000000 | 110 | 01111111111111111101111111111110 |  0  0  0 
 10000000000000000010000000000001 | 10000000000000000000000000000000 | 111 | 10000000000000000010000000000001 |  0  0  0 
------------------------------------------------------------------------------------------------------------------------
Test with Random Numbers
 00000100001001010010001101000111 | 00010000110100010110010100001001 | 000 | 00010100111101101000100001010000 |  0  0  0 
 00000100001001010010001101000111 | 00010000110100010110010100001001 | 001 | 11110011010100111011111000111110 |  0  0  0 
 00000100001001010010001101000111 | 00010000110100010110010100001001 | 010 | 00000000000000000000000000000001 |  0  0  0 
 00000100001001010010001101000111 | 00010000110100010110010100001001 | 011 | 00010100111101000100011001001110 |  0  0  0 
 00000100001001010010001101000111 | 00010000110100010110010100001001 | 100 | 00000000000000010010000100000001 |  0  0  0 
 00000100001001010010001101000111 | 00010000110100010110010100001001 | 101 | 11111111111111101101111011111110 |  0  0  0 
 00000100001001010010001101000111 | 00010000110100010110010100001001 | 110 | 11101011000010101001100010110000 |  0  0  0 
 00000100001001010010001101000111 | 00010000110100010110010100001001 | 111 | 00010100111101010110011101001111 |  0  0  0 
```

While testing our ALU with this testbench, we caught an error with our third test. Our ALU was not correctly changing overflow to 0 when the SLT function was enabled.

## Timing Analysis

In addition to the propegation delays that each function causes, 190 delay is added by the 8 input multiplexer which controls which function's output is propagated, 110 is added from the SLTControl, and 70 is added by the SLTinator. These added delays are included in the following worst propegation delays for each function.

Mode | Delay
-----|-----
Add | 2370
Subtract | 2380
SLT | 2380
XOR | 450
AND | 440
NAND | 430
NOR | 430
OR | 440

SLT uses the subtract function and contributes no additional delay, thus having the same propegation delay.

For Add and Subtract, the first bit's worst propegation delay is A/B to CarryOut and the rest of the bit's delay comes from CarryIn to CarryOut.

## Work Plan Reflection

We followed our work plan fairly closely, and it was relatively accurate in terms of total hours breakdowns of tasks. Because we wrote the plan before we had a full plan for the system's structure, we implemented the functions a bit out of order and started with *add* and *subtract*. Additionally, some of our timing estimates were a bit off; it took us significantly less time for the generic gates and significantly more time for the SLT than our original plan.

At one point, we questioned our decision to do a one-bit ALU module, and spent a fair amount of time assessing our high-level architecture and eventually coming to the conclusion that a one-bit ALU was fine. Overall, we spent around 6 or 7 hours on this lab, which is within a reasonable margin of our fairly ambitious 5-hour estimate.
