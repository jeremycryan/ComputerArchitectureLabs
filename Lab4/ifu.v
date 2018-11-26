`define AND and #30
`define XOR xor #50
`define NOT not #10

`include "instruction_memory.v"
//Instruction Fetch Unit and Instruction Memory, Outputs an Instruction to
//Instruction Decode 

module ifu
(
    output[31:0] instruction,		// Instruction, goes to ID 
    output[31:0] pcStore,			// Program counter + 8, used for JAL command
    output doing_branch_not,
    input[31:0] pcStore_ex,         // The value of pcStore propegated from the Exec reg wall
    input[25:0] targetInstr_ex,		// Target instruction for J-type commands
    input[15:0] imm16_ex,			// 16-bit immediate used for branch commands
    input[31:0] jRrs_ex,			// Output of R[rs], used for JR commands
    input branch_ex,jump_ex, ALUZero_ex, bne_ex, jl_ex, jr_ex, pc_en, clk   // Flags for data path and instruction types
);

reg[31:0] pc;					// Program counter reg
wire[31:0] pcEffect;            // PC that gets used
wire[29:0] address;             // Instruction ADdress
wire[31:0] immExtend;			// Sign-extended immediate
wire[31:0] addend;				// Item being added to PC output --- used in branches
wire[31:0] sum;					// Output of adder
wire[31:0] concatenate;			// Used with sign-extended immediate
wire[31:0] pcNext;				// Next value of program counter
wire[31:0] addendInter;			// Intermediate value of addend
wire[31:0] jumpAddress;			// Address to jump to

wire do_branch, branch_condition, carryIn;

assign doing_branch_not = carryIn; // Forwards value outside IF

// Initialize program counter at 0
initial begin
    pc <= 32'b0;
end

assign pcStore = sum;
assign address = pc[29:0];

signExtend1632 extend(immExtend,imm16_ex);
`XOR condition(branch_condition,ALUZero_ex,bne_ex); 	// Takes care of BNE and BEQ
`AND branchy(do_branch,branch_ex,branch_condition);// Decides if to branch
`NOT noty(carryIn, do_branch);              // Carryin for adder = 1 if not branching, =0 if branching
mux2_32 addMux1(addendInter,32'b0,immExtend,do_branch);
mux2_32 addMux2(addend,addendInter,32'b1,jl_ex);
mux2_32 pcEffectMux(pcEffect,pc,pcStore_ex,branch_ex);

// Add 4 to program counter every tick; add more on branch commands
Adder32Bit adder(
    .sum(sum),
    .carryout(),
    .a(pcEffect),
    .b(addend),
    .carryin(carryIn)
);

assign concatenate = {pcEffect[31:28],targetInstr_ex};
mux2_32 jumpMux1(jumpAddress, concatenate, jRrs_ex, jr_ex);
mux2_32 jumpMux2(pcNext,jumpAddress,sum,jump_ex); 

// Assign pc to pcNext on clk edge
always @(posedge clk)begin
    if(pc_en)
        pc <= pcNext;
end

instruction_memory instr_mem(clk, instruction, {address,2'b00});
endmodule
