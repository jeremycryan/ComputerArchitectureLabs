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
wire op,shamt,funct;
assign op = inst[31:26];
assign shamt = inst[10:6];
assign funct = inst[5:0];

assign rs = inst[25:21];
assign rt = inst[20:16];
assign rd = [15:11];
assign imm16 = [15:0];
assign target_instr = [25:0];

always @(op)begin
// Branch signal logic
if((op==6'b000100) || (op==6'b000101)
    branch = 1;
else 
    branch = 0;

// Jump signal logic
if((op==6'b000010)||(op==6'b000011)||(op==6'b0 && funct==6'b001000))
    jump = 0;
else
    jump = 1;
end

// ALusrc signal logic, ALUsrc is true on I type instructions
if((op!=6'b0)&&(op!=6'b10)&&(op!=6'b11)&&(op<6'b10000 && op >6'b010100))
    ALUsrc = 1;
else
    ALUsrc = 0;
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
