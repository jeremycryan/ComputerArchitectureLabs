# Lab 0 Report



![Our GTKwave output.](https://raw.githubusercontent.com/jeremycryan/ComputerArchitectureLabs/master/Lab0/LAB0_wave.JPG)

__**Test Case Explanation**__

With our selected simulated test cases, we have three catagories that our tests fall in. First, we tested basic sums. Second we tested carryout cases. Third we tested overflow cases. We tried to have our carryout cases and overflow cases have both overlapping and non overlapping tests so we can verify that overflow detection works regardless if there is a carryout.

We also did an exhaustive test of all possible inputs but only specifically looked at a handful in closer detail for the catagories previously described.

__**Test Failures and Fixes**__

We did not have any specific test case failures. However, we did at first displayed the bits with the LSB on the left and the MSB on the right, which was quickly fixed but did not affect the output.

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
