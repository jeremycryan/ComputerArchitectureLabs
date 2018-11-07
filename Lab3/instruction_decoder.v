module instruction_decoder (

    // 32-bit instruction
    input[31:0] inst,

    // Outputs that are just parts of the input
    output[4:0] rs,
    output[4:0] rt,
    output[4:0] rd,
    output[15:0] imm16,
    output[25:0] target_instr,

    // Outputs that require logic
    output regDst,
    output regWr,
    output memWr,
    output memToReg,
    output ALUcntrl,
    output ALUsrc, 
    output jump,
    output branch

);

// Nathaniel add code above this line. Jeremy add code below this line.

endmodule
