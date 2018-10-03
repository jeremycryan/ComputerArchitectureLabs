`include "sub.v"
`include "mux.v"

`define AND and #20
`define XOR xor #20
`define OR or #20
`define NOR nor #20
`define NAND nand #20
`define NOT not #10


// One bit ALU slice
module ALUOneBit
(
    output out,
    output carryout,
    input a,
    input b,
    input carryin,
    input[2:0] control
);

    wire[7:0] results;
    wire addCarryOut, subCarryOut;

    assign results[3] = 1'b0;
    AdderOneBit adder(results[0],addCarryOut,a,b,carryin);
    SubtractorOneBit sub(results[1], subCarryOut,a,b,carryin);
    `AND andGate(results[4], a,b);
    `XOR xorGate(results[2], a,b);
    `OR orGate(results[7], a,b);
    `NOR norGate(results[6],a,b);
    `NAND nandGate(results[5],a,b);

    mux8 mux(out, results,control);

    wire mux1, mux2;
    wire controlnot;

    `NOT muxNOT(controlnot, control[0]);
    `AND muxAND1(mux1, controlnot, addCarryOut);
    `AND muxAND2(mux2, control[0], subCarryOut);
    `OR muxOR(carryout, mux1, mux2);

endmodule

// Full ALU 32 bit
module ALU32Bit(
    output[31:0] out,
    output carryout,
    output overflow,
    output zero,
    input[31:0] a,
    input[31:0] b,
    input[2:0] control
);

    wire[31:0] carryouts;
    wire carryin;

    assign carryin = control[0];
   
    // strings 32 one bit alu's together
    genvar i;
    generate
        for(i=0;i<32; i=i+1)
        begin:genblock
            if(i==0)
            begin
                ALUOneBit alu(out[i],a[i],b[i],carryin,control);
            end
            else
            begin
                ALUOneBit alu(out[i],a[i],b[i],carryouts[i-1],control);
            end
        end
    endgenerate
endmodule
