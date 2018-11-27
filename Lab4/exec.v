`include "alu.v"
`include "sign_ext.v"

module exec(
    // System clock
    input clk,

    // Register Elements
    input[31:0] da,
    input[31:0] db,
    input[15:0] imm16,

    // Control Signals
    input[2:0] ALUCntrl,
    input[31:0] pcStore,
    input ALUSrc, jl,

    // Outputs
    output[31:0] ALUResult,
    output ALUZero
);

    wire[31:0] extended_imm;
    wire[31:0] ALU_in_2;
    wire[31:0] ALUResult_inter;

    // Sign-extend immediate
    signExtend1632 extend (
        .out32(extended_imm),
        .in16(imm16)
    );

    // Mux for ALU's second operand
    mux2_32 alu_src_sel(ALU_in_2, extended_imm, db, ALUSrc);
    mux2_32 alu_output(ALUResult, ALUResult_inter, pcStore, jl);
    // Create ALU
    ALU32Bit alu(
        .out(ALUResult_inter),
        .carryout(),
        .overflow(),
        .zero(ALUZero),
        .a(da),
        .b(ALU_in_2),
        .control(ALUCntrl)
    );

endmodule
