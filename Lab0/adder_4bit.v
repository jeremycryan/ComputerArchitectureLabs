// Four-bit ripple adder

`include "adder.v"

`define AND and #50
`define XOR xor #50
`define OR or #50

module FullAdder4bit
(
  output[3:0] sum,  // 2's complement sum of a and b
  output carryout,  // Carry out of the summation of a and b
  output overflow,  // True if the calculation resulted in an overflow
  input[3:0] a,     // First operand in 2's complement format
  input[3:0] b      // Second operand in 2's complement format
);
    // Your Code Here

    wire C0, C1, C2; // the three intermidiate carryouts

    // one bit adders
    adder_onebit adder0 (sum[0], C0, a[0], b[0], 1'b0); // the carryin for first bit adder is tied to 0
    adder_onebit adder1 (sum[1], C1, a[1], b[1], C0);
    adder_onebit adder2 (sum[2], C2, a[2], b[2], C1);
    adder_onebit adder3 (sum[3], carryout, a[3], b[3], C2);

    `XOR over_detect (overflow, carryout, C2); // XOR's final carryin and final carryout for overflow detection

endmodule

