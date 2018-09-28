# Lab 0 Report



![Our GTKwave output.](https://raw.githubusercontent.com/jeremycryan/ComputerArchitectureLabs/master/Lab0/LAB0_wave.JPG)

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
