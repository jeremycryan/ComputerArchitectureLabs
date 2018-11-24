`include "ifu.v"

module ifuTest();

wire[29:0] subAddress; 		// Wire for instruction address, without two least significant bits
reg[25:0] targetInstr;		// Target instruction for J-type commands
reg[15:0] imm16;		// 16-bit immediate for branch commands
reg branch, jump;		// Flags for branches and jumps
reg clk;			// System clock
wire[31:0] fullAddress;		// Full instruction address
assign fullAddress = {subAddress,2'b00};

// Instantiate instruction fetch unit
ifu myIFU(subAddress, targetInstr, imm16, branch, jump, clk);

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
    #10000
    assign branch = 1'b0;
    #50000

    // Test Branch with negative imm16
    assign branch = 1'b1;
    assign imm16 = 16'b1111111111111110;
    #10000
    assign branch = 1'b0;
    #50000
    
    $finish();
end
endmodule
