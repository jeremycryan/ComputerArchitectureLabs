`include "ifu.v"

module ifuTest();

wire[29:0] subAddress;
reg[25:0] targetInstr;
reg[15:0] imm16;
reg branch, jump, clk;
wire[31:0] fullAddress;

assign fullAddress = {subAddress,2'b00};
ifu myIFU(subAddress, targetInstr, imm16, branch, jump, clk);

initial begin
    clk <= 1'b0;
end
always begin
    #5000
    clk <= ~clk;
end

initial begin
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
