// 1 Bit Subractor

`include "add.v"

`define NOT not #10

module SubtractorOneBit(
    output diff,
    output carryout,
    input a,
    input b,
    input carryin
);

   wire nb; // inverted b

   `NOT bNOT(nb, b); // sets nb's value
   
   AdderOneBit adder(diff,carryout,a,nb,carryin); // adds a and inverted b
endmodule
