`include "add.v"
`include "sub.v"

`define AND and #50
`define XOR xor #50
`define OR or #50
`define NOR nor #50
`define NAND nand #50

module ALUOneBit
(
    output out,
    output carryout,
    input a,
    input b,
    input carryin,
    input[2:0] control
);

    wire addOut, subOut, andOut, xorOut, orOut, norOut, nandOut;
    wire addCarryOut, subCarryOut;

    AdderOneBit adder(addOut,carryout,a,b,carryin);
