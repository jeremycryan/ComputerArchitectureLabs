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

    always @(*) begin
        
        // Instruction is R type if op code is 0 or 16-20
        if ((op == 6'b000000) || (op[5:2] == 6'b0100))
            regDst = 1'b1;
        else
            regDst = 1'b0;

        // Write to register on load word, jump and link, and most math/logic
        if ((regDst) || //TODO

        // Write to memory only on store commands
        if (op == 8'b101011)
            memWr = 1'b1;
        else
            memWr = 1'b0;
        
         
        
    end

endmodule
