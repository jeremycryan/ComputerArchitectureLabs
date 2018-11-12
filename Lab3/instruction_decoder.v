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
    output reg regDst,
    output reg regWr,
    output reg memWr,
    output reg memToReg,
    output reg [2:0] ALUcntrl,
    output reg ALUsrc, 
    output reg jump,
    output reg branch

);
wire[5:0] op;
wire[4:0] shamt;
wire[5:0] funct;
assign op = inst[31:26];
assign shamt = inst[10:6];
assign funct = inst[5:0];

assign rs = inst[25:21];
assign rt = inst[20:16];
assign rd = inst[15:11];
assign imm16 = inst[15:0];
assign target_instr = inst[25:0];

always @(*)begin
// Branch signal logic
if((op==6'b000100) || (op==6'b000101))
    branch = 1'b1;
else 
    branch = 1'b0;

// Jump signal logic
if((op==6'b000010)||(op==6'b000011)||(op==6'b0 && funct==6'b001000))
    jump = 1'b0;
else
    jump = 1'b1;


// ALusrc signal logic, ALUsrc is true on I type instructions
if((op!==6'b0)&&(op!==6'b10)&&(op!==6'b11)&&((op<6'b010000) || (op >6'b010100)))
    ALUsrc = 1'b1;
else
    ALUsrc = 1'b0;

// memToReg is true if LW instruciton - op==100011
if(op==6'b100011)
    memToReg = 1'b1;
else
    memToReg = 1'b0;

// ALUcntrl signal
// ALucntrl == 0, which is add operation, for LW,SW,ADDI and ADD
if((op==6'b100011)||(op==6'b101011)||(op==6'b1000)||((op==6'b0)&&(funct==6'b100000)))
    ALUcntrl = 3'b0;
// ALUcntrl == 1, which is sub operation, for SUB
if((op==6'b0)&&(funct==6'b100010))
    ALUcntrl = 3'b1;
// ALUcntrl ==2, which is SLT
if((op==6'b0)&&(funct==6'b101010))
    ALUcntrl = 3'h2;
// ALUcntrl == 3, which is XOR, for XORI, BEQ and BNE
if((op==6'h4)||(op==6'h5)||(op==6'he))
    ALUcntrl = 3'h3;

// Regwr signal logic, true for LW, JL, XORI, ADDI, ADD, SUB, and SLT
if((op==6'h23)||(op==6'h3)||(op==6'he)||(op==6'h8)||((op==6'h0)&&((funct==6'h20)||(funct==6'h22)||(funct==6'h2a))))
    regWr = 1'b1;
else
    regWr = 1'b0;


// Instruction is R type if op code is 0 or 16-20
if ((op == 6'b000000) || (op[5:2] == 6'b0100))
    regDst = 1'b1;
else
    regDst = 1'b0;

// Write to memory only on store commands
if (op == 8'b101011)
    memWr = 1'b1;
else
    memWr = 1'b0;
end

endmodule
