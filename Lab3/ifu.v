`define AND and #30
//Instruction Fetch Unit which outputs an address
//to Instruction Memory and is able to jump and
//branch when provided appropriate control signals

module ifu
(
    output[29:0] address,
    input[25:0] targetInstr,
    input[15:0] imm16,
    input branch,jump, zero, clk
);

reg[31:0] pc;
wire[31:0] immExtend;
wire[31:0] addend;
wire[31:0] sum;
wire[31:0] concatenate;
wire[31:0] pcNext;

wire do_branch;

initial begin
    pc <= 32'b00000000000000000000000000000000;
end

assign address = pc[29:0];
signExtend1632 extend(immExtend,imm16);
`AND branchy(do_branch,branch,zero);
mux2_32 addMux(addend,32'b00000000000000000000000000000000,immExtend,do_branch);
Adder32Bit adder(
    .sum(sum),
    .carryout(),
    .a(pc),
    .b(addend),
    .carryin(1'b1)
);

assign concatenate = {pc[31:28],targetInstr};
mux2_32 jumpMux(pcNext,concatenate,sum,jump); 

// Assign pc to pcNext on clk edge
always @(posedge clk)begin
    pc <= pcNext;
end

endmodule
