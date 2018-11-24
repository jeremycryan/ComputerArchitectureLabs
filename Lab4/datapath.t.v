`include "datapath.v"

module datapath_test();

    // Clock signal
    reg clk;
    
    // Instructions
    reg[4:0] rs, rt, rd;
    reg[15:0] imm16;

    // Control signals
    reg RegWr;
    reg RegDst;
    reg ALUSrc;
    reg[2:0] ALUCntrl;
    reg MemWr;
    reg MemToReg;

    // Set up clock
    initial begin
        clk <= 1'b0;
    end

    // Run clock
    always begin
        clk <= ~clk; #1000
    end

    datapath dp (
        .clk(clk),
        .rs(rs),
        .rt(rt),
        .rd(rd),
        .imm16(imm16),
        .RegWr(RegWr),
        .RegDst(RegDst),
        .ALUSrc(ALUSrc),
        .ALUCntrl(ALUCntrl),
        .MemWr(MemWr),
        .MemToReg(MemToReg)
    );

   //TODO implement test after decoder is done 

endmodule
