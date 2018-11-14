`include "instruction_decoder.v"
`include "ifu.v"
`include "datapath.v"
`include "instruction_memory.v"

module cpu(
    input clk
);

wire[29:0] address;		// Address of current instruction, minus last two bits (should be zero)
wire[31:0] inst;		// Value of current instruction
wire[31:0] pcStore;		// Value of program counter + 8, stored during jump and link command
wire[4:0] rs;			// Section of inst corresponding to first register address for R/I-types
wire[4:0] rt;			// Section of inst corresponding to second register address for R/I-types
wire[4:0] rd;			// Section of inst corresponding to third register address for R-types
wire[15:0] imm16;		// Section of inst corresponding to 16-bit immediate value for I-types
wire[25:0] target_instr; 	// Section of inst corresponding to 26-bit jump target for J-types
wire[2:0] ALUcntrl;		// Control signals for ALU, based on function 
wire[31:0] jRrs; 		// Jump address from R[rs] for JR instruction
wire[5:0] op;			// Section of inst corresponding to op code
assign op = inst[31:26];
wire regDst, regWr, memWr, memToReg, ALUsrc, jump, branch, zero, bne, jl, jr;	// Flags for datapath behavior

// Initialize CPU modules
instruction_memory instructy(clk,inst,{address,2'b00});
ifu mr_ifu(address, pcStore, target_instr, imm16, jRrs, branch, jump, zero, bne, jl, jr, clk);
instruction_decoder enigma(inst, rs, rt, rd, imm16, target_instr, regDst, regWr, memWr, memToReg, ALUcntrl, ALUsrc, jump, branch, bne, jl, jr);
datapath data(clk, rs, rt, rd, imm16, regWr, regDst, ALUsrc, ALUcntrl, memWr, memToReg, zero, jl, pcStore, jRrs);

endmodule
