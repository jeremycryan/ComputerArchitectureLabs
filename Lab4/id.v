`include "instruction_decoder.v"
`include "regfile.v"
`include "mux.v"

module id(

   // 32-bit instruction from instruction memory
   input[31:0] inst,

   // Register inputs from WR stage
   input[31:0] dw,
   input[4:0] wr_addr,
   input wr_en, // Note that this should be regWr, but earlier in the pipeline

   // Register outputs
   output[31:0] da,
   output[31:0] db,
   output[15:0] imm16,
   output[4:0] rd,
   output[4:0] rt,
   output[25:0] target_instr,

   // Control signals
   output regDst,
   output regWr,
   output memWr,
   output memToReg,
   output[2:0] ALUcntrl,
   output ALUsrc, 
   output jump,
   output branch,
   output bne,
   output jl,
   output jr,

   // Clock
   input clk
);

// This module takes in an instruction and inputs from the WR stage, and outputs
// loaded register values and relevant control signals for later stages.

////////////////////////////////////////////////////////////////
// ----------------- INSTRUCTION DECODE ----------------------//
////////////////////////////////////////////////////////////////

   wire[4:0] rs;

   // Make decoder instance
   instruction_decoder dec (

      .inst(inst),

      .rs(rs),
      .rt(rt),
      .rd(rd),
      .imm16(imm16),
      .target_instr(target_instr),

      .regDst(regDst),
      .regWr(regWr),
      .memWr(memWr),
      .memToReg(memToReg),
      .ALUcntrl(ALUcntrl),
      .ALUsrc(ALUsrc),
      .jump(jump),
      .branch(branch),
      .bne(bne),
      .jl(jl),
      .jr(jr)

   );

///////////////////////////////////////////////////////////////
// -------------------- REGISTER FILE ---------------------- //
///////////////////////////////////////////////////////////////

    // Initialize wires
    wire[4:0] reg_wr_addr_inter;
    wire[31:0] dwInter;
    wire jRrs;
    assign jRrs = da;

    // Create register
    regfile reggie (
        .ReadData1(da),
        .ReadData2(db),
        .WriteData(dw),
        .ReadRegister1(rs),
        .ReadRegister2(rt),
        .WriteRegister(wr_addr),
        .RegWrite(wr_en),
        .Clk(clk)
    );

endmodule
