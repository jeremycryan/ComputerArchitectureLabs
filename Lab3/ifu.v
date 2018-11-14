`define AND and #30
`define XOR xor #50
//Instruction Fetch Unit which outputs an address
//to Instruction Memory and is able to jump and
//branch when provided appropriate control signals

module ifu
(
    output[29:0] address,			// Instruction address, without 2 least significant bits
    output[31:0] pcStore,			// Program counter + 8, used for JAL command
    input[25:0] targetInstr,			// Target instruction for J-type commands
    input[15:0] imm16,				// 16-bit immediate used for branch commands
    input[31:0] jRrs,				// Output of R[rs], used for JR commands
    input branch,jump, zero, bne, jl, jr, clk   // Flags for data path and instruction types
);

reg[31:0] pc;					// Program counter
wire[31:0] immExtend;				// Sign-extended immediate
wire[31:0] addend;				// Item being added to PC output --- used in branches
wire[31:0] sum;					// Output of adder
wire[31:0] concatenate;				// Used with sign-extended immediate
wire[31:0] pcNext;				// Next value of program counter
wire[31:0] addendInter;				// Intermediate value of addend
wire[31:0] jumpAddress;				// Address to jump to

wire do_branch, branch_condition;

// Initialize program counter at 0
initial begin
    pc <= 32'b0;
end

assign pcStore = sum;
assign address = pc[29:0];

signExtend1632 extend(immExtend,imm16);
`XOR condition(branch_condition,zero,bne); 	// Takes care of BNE and BEQ
`AND branchy(do_branch,branch,branch_condition);// Decides if to branch
mux2_32 addMux1(addendInter,32'b0,immExtend,do_branch);
mux2_32 addMux2(addend,addendInter,32'b1,jl);

// Add 4 to program counter every tick; add more on branch commands
Adder32Bit adder(
    .sum(sum),
    .carryout(),
    .a(pc),
    .b(addend),
    .carryin(1'b1)
);

assign concatenate = {pc[31:28],targetInstr};
mux2_32 jumpMux1(jumpAddress, concatenate, jRrs, jr);
mux2_32 jumpMux2(pcNext,jumpAddress,sum,jump); 

// Assign pc to pcNext on clk edge
always @(posedge clk)begin
    pc <= pcNext;
end

endmodule
