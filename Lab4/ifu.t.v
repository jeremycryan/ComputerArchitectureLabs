`include "ifu.v"

module ifuTest();

wire[31:0] instruction;
reg[25:0] targetInstr;		// Target instruction for J-type commands
reg[15:0] imm16;		// 16-bit immediate for branch commands
reg[31:0] jRrs;
reg[31:0] pcStore_ex;
reg branch, jump, ALUZero, bne, jl, jr, pc_en;		// Flags for branches and jumps
reg clk;			// System clock
wire[31:0] pcStore;

// Instantiate instruction fetch unit
ifu myIFU(instruction, pcStore, pcStore_ex, targetInstr, imm16, jRrs, branch, jump, ALUZero, bne, jl, jr, pc_en,clk);

// Set up clock, and run at constant rate
initial begin
    clk <= 1'b0;
end
always begin
    #5000
    clk <= ~clk;
end

// Run test
initial begin

    // Dump variables to analyze with GTKWave
    $dumpfile("ifu.vcd");
    $dumpvars();

    // Test instruction increment
    assign jump = 1'b1;
    assign branch = 1'b0;
    assign imm16 = 16'b0;
    assign targetInstr = 26'b0;
    assign pcStore_ex = 32'b0;
    assign jRrs = 32'b0;
    assign ALUZero = 1'b0;
    assign bne = 1'b0;
    assign jl = 1'b0;
    assign jr = 1'b0;
    assign pc_en = 1'b1;
    #150000

    // Test Jump Instruction
    assign jump = 1'b0;
    assign targetInstr = 26'b1100;
    #10000
    assign jump = 1'b1;
    #15000

    // Test Branch with positive imm16
    assign branch = 1'b1;
    assign imm16 = 16'b11;
    assign ALUZero = 1'b1; 
    #10000
    assign branch = 1'b0;
    #50000

    
    $finish();
end
endmodule
