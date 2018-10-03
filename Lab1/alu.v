`include "add.v"
`include "sub.v"
`include "mux.v"

`define AND and #20
`define XOR xor #20
`define OR or #20
`define NOR nor #20
`define NAND nand #20

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

    AdderOneBit adder(addOut,addCarryOut,a,b,carryin);
    SubtractorOneBit sub(subOut, subCarryOut,a,b,carryin);
    AND andGate(andOut, a,b);
    XOR xorGate(xorOut, a,b);
    OR orGate(orOut, a,b);
    NOR norGate(norOut,a,b);
    NAND nandGate(nandOut,a,b);

    mux8 (out, addOut,subOut,xorOut, 1'b0,andOut,nandOut,norOut,orOut,control);

endmodule
