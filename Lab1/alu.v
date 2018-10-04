`include "sub.v"
`include "slt.v"

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

    assign results[2] = 1'b0;
    AdderOneBit adder(results[0],addCarryOut,a,b,carryin);
    SubtractorOneBit sub(results[1], subCarryOut,a,b,carryin);
    `AND andGate(results[4], a,b);
    `XOR xorGate(results[3], a,b);
    `OR orGate(results[7], a,b);
    `NOR norGate(results[6],a,b);
    `NAND nandGate(results[5],a,b);

    mux8 mux(out, results,control); // 8-bit mux for function control

    mux2 mux2(carryout, addCarryOut, subCarryOut, control[0]); // 2-bit mux for carryout

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
    wire[31:0] tempOut;
    wire[2:0] newControl;
    wire is_slt;
    wire[31:0] carryouts;
    wire carryin;

    SLTControl sltcontrol(control, newControl, is_slt);

    assign carryin = newControl[0];
   
    // strings 32 non-slt one bit alu's together
    genvar i;
    generate
        for(i=0;i<32; i=i+1)
        begin:genblock
            if(i==0)
            begin
                ALUOneBit alu(tempOut[i],carryouts[i],a[i],b[i],carryin,newControl);
            end
            else
            begin
                ALUOneBit alu(tempOut[i],carryouts[i],a[i],b[i],carryouts[i-1],newControl);
            end
        end
    endgenerate
    
    assign carryout = carryouts[31];

    // Converts non-slt outs to slt outs if is_slt is true
    // else just forwards signal
    SLTinator sltinator(tempOut,is_slt,out);
endmodule
