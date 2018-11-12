`include "instruction_decoder.v"

module instruction_decoder_test();
reg[31:0] inst;
wire[4:0] rs;
wire[4:0] rt;
wire[4:0] rd;
wire[15:0] imm16;
wire[25:0] target_instr; 
wire[2:0] ALUcntrl;
wire regDst, regWr, memWr, memToReg, ALUsrc, jump, branch;

instruction_decoder decody(inst,rs,rt,rd,imm16,target_instr,regDst,regWr,memWr,memToReg,ALUcntrl,ALUsrc,jump,branch);

initial begin
$dumpfile("instruction_decoder.vcd");
$dumpvars();
assign inst=32'b10001110101010101111111111111111;//LW
#100
assign inst=32'b10101110101010101111111111111111;//SW
#100
assign inst=32'b00001011111111111111111111111111;//J
#100
assign inst=32'b00000010101010101010111111001000;//JR
#100
assign inst=32'b00001111111111111111111111111111;//JL
#100
assign inst=32'b00010010101010101111111111111111;//BEQ
#100
assign inst=32'b00010110101010101111111111111111;//BNE
#100
assign inst=32'b00111010101010101111111111111111;//XORI
#100
assign inst=32'b00100010101010101111111111111111;//ADDI
#100
assign inst=32'b00000010101010101010111111100010;//SUB
#100
assign inst=32'b00000010101010101010111111100000;//ADD
#100
assign inst=32'b00000010101010101010111111101010;//SLT
#100
$finish();
end

endmodule
