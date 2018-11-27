`include "instruction_decoder.v"
`include "regfile.v"

module id(

   // 32-bit instruction from instruction memory
   input[31:0] inst,

   // Register inputs from WR stage
   input[31:0] dw,
   input[4:0] wr_addr,
   input wr_en, // Note that this should be regWr, but earlier in the pipeline

   // Register outputs
   output[31:0] da_out,
   output[31:0] db_out,
   output[15:0] imm16,
   output reg[4:0] wr_addr_id, // not to be confused with wr_addr, this is for outgoing controls
   output[4:0] rs,
   output[4:0] rt,
   output[25:0] target_instr,

   // Control signals
   output[2:0] ALUcntrl,
   output regDst,
   output regWr,
   output memWr,
   output memToReg,
   output ALUsrc, 
   output jump,
   output branch,
   output bne,
   output jl,
   output jr,

   // ALU outputs from future stages, with control signals.
   // Bits 31:0   --- ALU output from that phase
   // Bits 36:32  --- write address from that phase
   // Bit  37     --- regWr from that phase
   // Any reads from the register should first check these values if they are
   // writing to the register we try to read from.
   input[37:0] ALUres_ex,
   input[37:0] ALUres_mem,

   // Clock
   input clk
);

// This module takes in an instruction and inputs from the WR stage, and outputs
// loaded register values and relevant control signals for later stages.

////////////////////////////////////////////////////////////////
// ----------------- INSTRUCTION DECODE ----------------------//
////////////////////////////////////////////////////////////////

   wire[4:0] rd;
   wire[31:0] da, db;
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
    wire[31:0] dwInter;
    wire[31:0] jRrs;
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

//////////////////////////////////////////////////////////////
// ---------------- SELECT OUTPUT --------------------------//
//////////////////////////////////////////////////////////////

// Sometimes we read from ALUres_ex or ALUres_mem rather than
// the register file.

    wire ex_met_a, mem_met_a; // Hold the state of whether each stage has
                              // met the condition of 1) writing to register
                              // and 2) sharing a write address


    // ALUres_ex should be used instead of register read or ALUres_mem
    assign ex_met_a = ~((ALUres_ex[36] ^ rs[4]) |
            (ALUres_ex[35] ^ rs[3]) |
            (ALUres_ex[34] ^ rs[2]) |
            (ALUres_ex[33] ^ rs[1]) |
            (ALUres_ex[32] ^ rs[0])) &
            ALUres_ex[37];
        
    // ALUres_mem should be used instead of register read, unless
    // ex_met is true. 
    assign mem_met_a = ~((ALUres_mem[36] ^ rs[4]) |
            (ALUres_mem[35] ^ rs[3]) |
            (ALUres_mem[34] ^ rs[2]) |
            (ALUres_mem[33] ^ rs[1]) |
            (ALUres_mem[32] ^ rs[0])) &
            ALUres_mem[37];

// Mux for selecting mem result or register out
    wire[31:0] mr_mux_0_out;
    mux2_32 mr_mux_0 (
        .out(mr_mux_0_out),
        .in0(da),
        .in1(ALUres_mem[31:0]),
        .sel(mem_met_a));

// Mux for selecting ex result or mux_0 out
    wire[31:0] mr_mux_1_out;
    mux2_32 mr_mux_1 (
        .out(mr_mux_1_out),
        .in0(mr_mux_0_out),
        .in1(ALUres_ex[31:0]),
        .sel(ex_met_a));

// -----------------------------------------------------------------------
// DO THE SAME THING FOR REGISTER READ PORT 2
// Sometimes we read from ALUres_ex or ALUres_mem rather than
// the register file.

    wire ex_met_b, mem_met_b; // Hold the state of whether each stage has
                              // met the condition of 1) writing to register
                              // and 2) sharing a write address


    // ALUres_ex should be used instead of register read or ALUres_mem
    assign ex_met_b = ~((ALUres_ex[36] ^ rt[4]) |
            (ALUres_ex[35] ^ rt[3]) |
            (ALUres_ex[34] ^ rt[2]) |
            (ALUres_ex[33] ^ rt[1]) |
            (ALUres_ex[32] ^ rt[0])) &
            ALUres_ex[37];
        
    // ALUres_mem should be used instead of register read, unless
    // ex_met is true. 
    assign mem_met_b = ~((ALUres_mem[36] ^ rt[4]) |
            (ALUres_mem[35] ^ rt[3]) |
            (ALUres_mem[34] ^ rt[2]) |
            (ALUres_mem[33] ^ rt[1]) |
            (ALUres_mem[32] ^ rt[0])) &
            ALUres_mem[37];

// Mux for selecting mem result or register out
    wire[31:0] mr_mux_2_out;
    mux2_32 mr_mux_2 (
        .out(mr_mux_2_out),
        .in0(db),
        .in1(ALUres_mem[31:0]),
        .sel(mem_met_b));

// Mux for selecting ex result or mux_0 out
    wire[31:0] mr_mux_3_out;
    mux2_32 mr_mux_3 (
        .out(mr_mux_3_out),
        .in0(mr_mux_2_out),
        .in1(ALUres_ex[31:0]),
        .sel(ex_met_b));

// Provide correct mux output for the whole module output
    assign da_out = mr_mux_1_out;
    assign db_out = mr_mux_3_out;

// -----------------------------------------------------------------
   wire[4:0] wr_addr_id_inter;

    always @(*) begin
    if(jl)
        wr_addr_id = 5'b11111;
    else
        wr_addr_id = wr_addr_id_inter;
    end

// Calculate write address for register file
    genvar i;
    generate
        for (i=0; i<5; i=i+1)
            mux2 muxxy (wr_addr_id_inter[i], rt[i], rd[i], regDst);
    endgenerate


endmodule
