`include "alu.v"
`include "sign_ext.v"
`include "datamemory.v"
`include "regfile.v"

module datapath (

    // System clock
    input clk,

    // Instruction elements
    input[4:0] rs,
    input[4:0] rt,
    input[4:0] rd,
    input[15:0] imm16,
    
    // Control signals
    input RegWr,		// If true, register file can be written to
    input RegDst,		// If true, rd is forwarded to register write address
    input ALUSrc,		// If true, ALU gets register output
    input[2:0] ALUCntrl,	// Control bits for ALU
    input MemWr,		// True if writing to data memory
    input MemToReg,		// True if data memory output is stored in register file
    // Zero output of ALU 
    output zero,
    input jl,           // if it is a jl instruction
    input[31:0] pcStore,// for jl instructions, to be stored in reg[31]
    output[31:0] jRrs   // for JR instructions
);

///////////////////////////////////////////////////////////////////////////
//------------------------ Register File --------------------------------//
///////////////////////////////////////////////////////////////////////////

    // Initialize wires
    wire[4:0] reg_wr_addr, reg_wr_addr_inter;
    wire[31:0] da, db, dw, dwInter;
    assign jRrs = da;

    // Generate multiplexer for register write input
    genvar i;
    generate  
    for(i=0; i<5; i=i+1) begin
        mux2 reg_wr_select1(reg_wr_addr_inter[i], rt[i], rd[i], RegDst);
        mux2 reg_wr_select2(reg_wr_addr[i],reg_wr_addr_inter[i],1'b1,jl); // if jl, address is 31
    end 
    endgenerate

    // If jl instruction, write pcStore to reg[31]
    mux2_32 dwMux(dw, dwInter, pcStore, jl);
    

    // Create register
    regfile reggie (
        .ReadData1(da),
        .ReadData2(db),
        .WriteData(dw),
        .ReadRegister1(rs),
        .ReadRegister2(rt),
        .WriteRegister(reg_wr_addr),
        .RegWrite(RegWr),
        .Clk(clk)
    );

//////////////////////////////////////////////////////////////////////////
//------------------------- Computation --------------------------------//
//////////////////////////////////////////////////////////////////////////

    // Initialize wires
    wire[31:0] extended_imm;
    wire[31:0] ALU_in_2;
    wire[31:0] ALU_out;

    // Sign-extend immediate
    signExtend1632 extender (
        .out32(extended_imm),
        .in16(imm16)
    );

    // Create mux for ALU source
    mux2_32 alu_src_sel (ALU_in_2, extended_imm, db, ALUSrc);

    // Create ALU
    ALU32Bit alu_0 (
        .out(ALU_out),
        .carryout(),		// TODO determine whether these
        .overflow(),		// outputs need to go somewhere
        .zero(zero),
        .a(da),
        .b(ALU_in_2),
        .control(ALUCntrl)
    );

//////////////////////////////////////////////////////////////////////////
//--------------------------- Data Memory ------------------------------//
//////////////////////////////////////////////////////////////////////////

    // Initialize wires
    wire[31:0] data_mem_out;

    // Create data memory unit
    datamemory data_mem_0 (
        .clk(clk),
        .dataOut(data_mem_out),
        .address(ALU_out),
        .writeEnable(MemWr),
        .dataIn(db)
    );     

    // Multiplexer to determine register write data
    mux2_32 reg_write_data (
        .out(dwInter),
        .in0(ALU_out),
        .in1(data_mem_out),
        .sel(MemToReg)
    );

endmodule
