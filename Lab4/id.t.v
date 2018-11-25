`include "id.v"

module instruction_decoder_test();
reg[31:0] inst;
wire[4:0] rs;
wire[4:0] rt;
wire[4:0] rd;
wire[15:0] imm16;
wire[25:0] target_instr; 
wire[2:0] ALUcntrl;
wire regDst, regWr, memWr, memToReg, ALUsrc, jump, branch;
reg clk;

id iddy(
    .inst(inst),

    .dw(32'h0),
    .wr_addr(5'h0),
    .wr_en(1'h0),

    .da(),
    .db(),
    .imm16(imm16),

    .rt(rt),
    .rd(rd),
    .target_instr(target_instr),
    .regDst(regDst),
    .regWr(regWr),
    .memWr(memWr),
    .memToReg(memToReg),
    .ALUcntrl(ALUcntrl),
    .ALUsrc(ALUsrc),
    .jump(jump),
    .branch(branch),

    .clk(clk)
);

initial
   clk <= 1'b0;

always
   #50 clk <= ~clk;

// Test each command type
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
