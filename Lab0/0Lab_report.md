# Lab 0 Report

In this lab, we designed and tested a 4-bit adder in Verilog, using the 1-bit adder module we constructed for HW2. We tested our Verilog implementation with a test bench, GTKWave, and by uploading onto a Diligent Zybo FPGA.

### Test Bench Output

The following is the output of our 4-bit adder test bench. In addition to the six hand-picked examples below, we had an exhaustive test bench output, but decided to spare you the pain of 256-lines of binary strings.

```
 A3 A2 A1 A0 | B3 B2 B1 B0 | S3 S2 S1 S0 | Co Ov 
  0  0  1  0 |  0  1  0  0 |  0  1  1  0 |  0  0
                   Expected:  0  1  1  0 |  0  0
  0  0  1  1 |  0  0  1  0 |  0  1  0  1 |  0  0
                   Expected:  0  1  0  1 |  0  0
Test Carry Out:
  1  0  1  0 |  0  1  0  1 |  1  1  1  1 |  0  0
                   Expected:  1  1  1  1 |  0  0
  1  1  1  1 |  0  1  0  0 |  0  0  1  1 |  1  0
                   Expected:  0  0  1  1 |  1  0
Test Overflow:
  0  1  0  1 |  0  1  1  1 |  1  1  0  0 |  0  1
                   Expected:  1  1  0  0 |  0  1
  1  1  0  1 |  1  0  0  1 |  0  1  1  0 |  1  1
                   Expected:  0  1  1  0 |  1  1
```

### GTKWave Output

After ensuring our device performed as expected with a truth table, we observed its timing behavior with GTKWave. We added a delay of 50 unspecified time units to each of our gates, and you can see that the output sums and overflow are staggered within each clock cycle. Additionally, this causes errors, especially in the overflow and carryout bits, where they have brief periods of behavior inconsistent with the truth table.

Our waveform is pictured below.

![GTKWave Output](https://github.com/jeremycryan/ComputerArchitectureLabs/blob/master/Lab0/LAB0_wave.JPG?raw=true)

### Test Case Explanation

With our selected simulated test cases, we identified three catagories that our tests fall in. First, we tested basic sums. Second we tested carryout cases. Third we tested overflow cases. We tried to have our carryout cases and overflow cases have both overlapping and non-overlapping tests so we could verify that overflow detection works regardless if there is a carryout.

We also did an exhaustive test of all possible inputs but only specifically looked at a handful in closer detail for the categories previously described.

### Test Failures and Fixes

We did not have any specific test case failures. We did at first display the bits with the LSB on the left and the MSB on the right, inconsistent with the truth table header, but it was quickly fixed and did not affect the output.

Input A | Input B | Expected Sum | CO | OF | Observed Sum | CO | OF | Rationale
--- | --- | --- | --- | --- | --- | --- | --- | ---
0001 | 1001 | 1010 | 0 | 0 | 1010 | 0 | 0 | Basic sum
0110 | 0010 | 1000 | 0 | 1 | 1000 | 0 | 1 | Basic sum
0001 | 0001 | 0010 | 0 | 0 | 0010 | 0 | 0 | Basic sum
0000 | 0000 | 0000 | 0 | 0 | 0000 | 0 | 0 | Basic sum
1100 | 0011 | 1111 | 0 | 0 | 1111 | 0 | 0 | Test commutative property
0011 | 1100 | 1111 | 0 | 0 | 1111 | 0 | 0 | Test commutative property
0111 | 1001 | 0000 | 1 | 0 | 0000 | 1 | 0 | Add opposite integers
1111 | 0001 | 0000 | 1 | 0 | 0000 | 1 | 0 | Add opposite integers
0010 | 1110 | 0000 | 1 | 0 | 0000 | 1 | 0 | Add opposite integers
1010 | 1100 | 0110 | 1 | 1 | 0110 | 1 | 1 | Test overflow with negatives
0111 | 0001 | 1000 | 0 | 1 | 1000 | 0 | 1 | Test overflow with positives
1000 | 1000 | 0000 | 1 | 1 | 0000 | 1 | 1 | Test overflow with carryout
0101 | 0100 | 1001 | 0 | 1 | 1001 | 0 | 1 | Test overflow without carryout
0100 | 0100 | 1000 | 0 | 0 | 1000 | 0 | 0 | Test overflow without carryout
1111 | 1111 | 1110 | 1 | 0 | 1110 | 1 | 0 | Test carryout without overflow
1111 | 0100 | 0011 | 1 | 0 | 0011 | 1 | 0 | Test carryout without overflow

### The Board

Here's a GIF of our programmed FPGA! It's a little hard to see the lights, but the board is behaving as expected.

<img src="https://github.com/jeremycryan/ComputerArchitectureLabs/blob/master/Lab0/FPGA.gif?raw=true" width="500"/>

### Summary Statistic

Here's the summary statistic output from Vivado for our project.

![GTKWave Output](https://github.com/jeremycryan/ComputerArchitectureLabs/blob/master/Lab0/FPGA_report.png?raw=true)
