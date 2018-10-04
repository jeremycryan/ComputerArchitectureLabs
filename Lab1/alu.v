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
    wire[31:0] preOut;
    wire[2:0] newControl;
    wire is_slt;
    wire[31:0] carryouts;
    wire carryin;
    wire display_co;
    wire overflow_occur;
    wire invert_last;

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
    
    `NOR nor1 (display_co, control[1], control[2]); // Only display carryout if in ADD or SUB mode
    `AND and1 (carryout, display_co, carryouts[31]);

    // Converts non-slt outs to slt outs if is_slt is true
    // else just forwards signal
    SLTinator sltinator(tempOut,is_slt,preOut);

    nor #320 zeros (zero, out[0], out[1], out[2], out[3], out[4], out[5], out[6], out[7], out[8], out[9], out[10], out[11], out[12], out[13],
    out[14], out[15], out[16], out[17], out[18], out[19], out[20], out[21], out[22], out[23], out[24], out[25], out[26], out[27], out[28], out[29],
    out[30], out[31]); // Calculate whether all inputs are zeros.

    `XOR overflows (overflow_occur, carryouts[30], carryouts[31]); // Calculate overflow by comparing last carryout and last carryin
    `AND show_overflow (overflow, display_co, overflow_occur);

    `AND and2 (invert_last, overflow_occur, is_slt);
    `XOR xor1 (out[0], invert_last, preOut[0]);  

    integer j;
    for (j=1;j<32;j=j+1) begin
        assign out[j] = preOut[j];
    end

endmodule
