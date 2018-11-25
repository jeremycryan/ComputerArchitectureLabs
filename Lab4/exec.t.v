`include "exec.v"

module exec_test();

reg clk;
reg[31:0] da;
reg[31:0] db;
reg[15:0] imm16;
reg[2:0] ALUCntrl;
reg ALUSrc;

wire[31:0] ALUResult;
wire ALUZero;

// Initialize clk 
initial begin
    clk <= 1'b0; 
end

// Run clock
always begin
    #5000
    clk <= ~clk; 
end

exec execy(clk,da,db,imm16,ALUCntrl,ALUSrc,ALUResult,ALUZero);

initial begin
$dumpfile("exec.vcd");
$dumpvars();
// Test ADD
assign da = 32'd45;
assign db = 32'd17;
assign imm16 = 16'd0;
assign ALUCntrl = 3'd0;
assign ALUSrc = 1'b1;
#20000
// Test ADDI
assign imm16 = 16'd3;
assign ALUSrc = 1'b0;
#20000
// Test Sub
assign ALUSrc = 1'b1;
assign ALUCntrl = 3'd1;
#20000
// Test AND
assign da = 32'b11111;
assign db = 32'b01011;
assign ALUCntrl = 3'd4;
#20000
$finish();
end
endmodule
