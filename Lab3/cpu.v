`include "instruction_decoder.v"
`include "ifu.v"
`include "datapath.v"
`include "instruction_memory.v"

module cpu(
input clk
);
wire[29:0] address;
wire[31:0] inst;
wire[31:0] pcStore;
wire[4:0] rs;
wire[4:0] rt;
wire[4:0] rd;
wire[15:0] imm16;
wire[25:0] target_instr; // output of instruction decoder
wire[2:0] ALUcntrl;
reg[25:0] ifu_target_instr; // input to ifu
wire[31:0] jRrs; // jump address from R[rs] for JR instruction
wire regDst, regWr, memWr, memToReg, ALUsrc, jump, branch, zero, bne, jl, jr;

wire[5:0] op;
assign op = inst[31:26];

instruction_memory instructy(clk,inst,{address,2'b00});
ifu mr_ifu(address, pcStore,  ifu_target_instr,imm16,jRrs,branch,jump,zero,bne,jl,jr,clk);
instruction_decoder enigma(inst,rs,rt,rd,imm16,target_instr,regDst,regWr,memWr,memToReg,ALUcntrl,ALUsrc,jump,branch,bne,jl,jr);
datapath data(clk, rs, rt, rd, imm16, regWr, regDst, ALUsrc, ALUcntrl, memWr, memToReg,zero,jl,pcStore,jRrs);

always @(*)begin
    if((op==6'h2)||(op==6'h3)) 
        ifu_target_instr = target_instr;
    else 
        ifu_target_instr = 26'h0; // TODO if instruction is jump register
end
endmodule
