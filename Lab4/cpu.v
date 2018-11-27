`include "ifu.v"
`include "id.v"
`include "exec.v"
`include "datamemory.v"


module cpu(
    input clk
);

// IF Wires
wire[31:0] instruction_if_pre;
wire[31:0] instruction_if;		// Value of current instruction
wire[31:0] pcStore_if;		// Value of program counter + 8, stored during jump and link command
wire[31:0] pcStore_8_if;

wire doing_branch_not;                 // Inverted value of whether or not a branch is being executed. Used to invalidate register wall values



// ID Wires 
wire[31:0] instruction_id;
wire[31:0] pcStore_id;
wire[31:0] pcStore_8_id;
wire[31:0] da_id;
wire[31:0] db_id;
wire[15:0] imm16_id;
wire[4:0] aw_id;            // Write Address
wire[4:0] rs_id;
wire[4:0] rt_id;			// Section of inst corresponding to second register address for R/I-types
wire[4:0] wr_addr_id;			// Section of inst corresponding to third register address for R-types
wire[25:0] target_instr_id; 	// Section of inst corresponding to 26-bit jump target for J-types
wire[2:0] ALUcntrl_id;		// Control signals for ALU, based on function 
wire regDst_id,
     regWr_id,  
     memWr_id, 
     memToReg_id, 
     ALUsrc_id, 
     jump_id, 
     branch_id, 
     bne_id, 
     jl_id, 
     jr_id;	


wire[165:0] idWires;
assign idWires = {pcStore_id, da_id, db_id, imm16_id, aw_id, rt_id, wr_addr_id, target_instr_id, ALUcntrl_id, regDst_id, regWr_id, memWr_id, memToReg_id, ALUsrc_id, jump_id, branch_id, bne_id, jl_id, jr_id};

// Exec Wires
wire[31:0] pcStore_ex;
wire[31:0] pcStore_8_ex;
wire[31:0] da_ex;
wire[31:0] db_ex;
wire[15:0] imm16_ex;
wire[4:0] aw_ex;            // Write Address
wire[4:0] rt_ex;			// Section of inst corresponding to second register address for R/I-types
wire[4:0] wr_addr_ex;			// Section of inst corresponding to third register address for R-types
wire[25:0] target_instr_ex; 	// Section of inst corresponding to 26-bit jump target for J-types
wire[2:0] ALUcntrl_ex;		// Control signals for ALU, based on function 
wire[31:0] ALUresult_ex;
wire regDst_ex,
     regWr_ex,  
     memWr_ex, 
     memToReg_ex, 
     ALUsrc_ex, 
     jump_ex, 
     branch_ex, 
     bne_ex, 
     jl_ex, 
     jr_ex,
     ALUzero_ex;	

wire[165:0] exWires_1;

wire[198:0] exWires_2;
assign exWires_2 = {pcStore_ex, da_ex, db_ex, imm16_ex, aw_ex, rt_ex, wr_addr_ex, target_instr_ex, ALUcntrl_ex, ALUresult_ex, regDst_ex, regWr_ex, memWr_ex, memToReg_ex, ALUsrc_ex, jump_ex, branch_ex, bne_ex, jl_ex, jr_ex, ALUzero_ex};



// Mem Wires
wire[31:0] pcStore_mem;
wire[31:0] pcStore_8_mem;
wire[31:0] da_mem;
wire[31:0] db_mem;
wire[15:0] imm16_mem;
wire[4:0] aw_mem;           // Write Address
wire[4:0] rt_mem;		// Section of inst corresponding to second register address for R/I-types
wire[4:0] wr_addr_mem;		// Section of inst corresponding to third register address for R-types
wire[25:0] target_instr_mem;	// Section of inst corresponding to 26-bit jump target for J-types
wire[2:0] ALUcntrl_mem;	// Control signals for ALU, based on function 
wire[31:0] ALUresult_mem;
wire[31:0] dw_mem;
wire regDst_mem,
     regWr_mem, 
     memWr_mem,
     memToReg_mem,
     ALUsrc_mem,
     jump_mem,
     branch_mem,
     bne_mem,
     jl_mem,
     jr_mem,
     ALUzero_mem,
     wr_en_mem;

wire regWr_id_pre, memWr_id_pre, jump_id_pre, jl_id_pre; // output values of the ID unit but not committed to idWires yet
reg stall;

////////////////////////////////////////////////////////////////////////////////
// Module Decleration
////////////////////////////////////////////////////////////////////////////////

// Instruction Fetch
ifu mrIF(instruction_if_pre, pcStore_if, pcStore_8_if, doing_branch_not, pcStore_ex,target_instr_ex,imm16_ex,da_ex,branch_ex,jump_ex,ALUzero_ex,bne_ex,jl_ex,jr_ex,~stall,clk);

// Instruction Decode
id  mrID(instruction_id,dw_mem,wr_addr_mem,regWr_mem,da_id,db_id,imm16_id,wr_addr_id,rs_id,rt_id,target_instr_id, ALUcntrl_id, regDst_id,regWr_id_pre,memWr_id_pre,memToReg_id,ALUsrc_id,jump_id_pre,branch_id,bne_id,jl_id_pre,jr_id,
        {regWr_ex,wr_addr_ex,ALUresult_ex},{regWr_mem,wr_addr_mem,dw_mem},
        clk);

// Execution
exec mrEXEC(clk,da_ex,db_ex,imm16_ex,ALUcntrl_ex,pcStore_8_ex,ALUsrc_ex,jl_ex,ALUresult_ex,ALUzero_ex);

// Memory
wire[31:0] dout;    // data out for data memory
datamemory mrMEM(clk,dout,ALUresult_mem,memWr_mem,db_mem);
mux2_32 dwMux(dw_mem,ALUresult_mem,dout,memToReg_mem);

// Register Walls
ifid ifidy(clk, ~stall,instruction_if, pcStore_if, pcStore_8_if, instruction_id, pcStore_id, pcStore_8_id);
idexec idexecy(clk,1'b1,{pcStore_id, pcStore_8_id, da_id, db_id, imm16_id, aw_id, rt_id, wr_addr_id, target_instr_id, ALUcntrl_id, regDst_id, regWr_id, memWr_id, memToReg_id, ALUsrc_id, jump_id, branch_id, bne_id, jl_id, jr_id}, {pcStore_ex, pcStore_8_ex, da_ex, db_ex, imm16_ex, aw_ex, rt_ex, wr_addr_ex, target_instr_ex, ALUcntrl_ex, regDst_ex, regWr_ex, memWr_ex, memToReg_ex, ALUsrc_ex, jump_ex, branch_ex, bne_ex, jl_ex, jr_ex});

execmem execmemy(clk, 1'b1,{pcStore_ex, pcStore_8_ex, da_ex, db_ex, imm16_ex, aw_ex, rt_ex, wr_addr_ex, target_instr_ex, ALUcntrl_ex, ALUresult_ex, regDst_ex, regWr_ex, memWr_ex, memToReg_ex, ALUsrc_ex, jump_ex, branch_ex, bne_ex, jl_ex, jr_ex, ALUzero_ex}, {pcStore_mem, pcStore_8_mem, da_mem, db_mem, imm16_mem, aw_mem, rt_mem, wr_addr_mem, target_instr_mem, ALUcntrl_mem, ALUresult_mem, regDst_mem, regWr_mem, memWr_mem, memToReg_mem, ALUsrc_mem, jump_mem, branch_mem, bne_mem, jl_mem, jr_mem, ALUzero_mem});

////////////////////////////////////////////////////////////////////////////////////////////////////
// Register Wall Invalidation Logic
////////////////////////////////////////////////////////////////////////////////////////////////////

wire flush_id, flush_if; // flushes when flush=1

`OR flushy(flush_if, ~jump_ex, ~doing_branch_not);

`OR flushy2(flush_id, flush_if, stall);

`AND id_and_0 (regWr_id, regWr_id_pre, ~flush_id);
`AND id_and_1 (memWr_id, memWr_id_pre, ~flush_id);
`OR id_and_2 (jump_id, jump_id_pre, flush_id);
`AND id_and_3 (jl_id, jl_id_pre, ~flush_id);

genvar i;
generate
    for (i=0; i<32; i=i+1)
        `AND instruction_if_and (instruction_if[i], instruction_if_pre[i], ~flush_if);
endgenerate

///////////////////////////////////////////////////////////////////////////////////////////////////
// Stall logic for LW command
///////////////////////////////////////////////////////////////////////////////////////////////////


// When LW is in the EX phase, if the next instruction is trying to access the
// register LW writes to, stall for one clock cycle.

// First, check whether the current EX and ID commands share a write address.


always @(*) begin
    // Check whether the command is writing to an address ID wants to read
    if ((wr_addr_ex == rs_id) | ((wr_addr_ex == rt_id)&&ALUsrc_id)) begin
        if(memToReg_ex) begin // Check whether EX holds a LW instruction
            if(~((wr_addr_ex == wr_addr_mem) && memToReg_mem)) // Check that you don't have a duplicate LW instruction ahead
                stall = 1'b1;
            else
                stall = 1'b0;
        end
        else 
            stall = 1'b0;
    end
    else
        stall = 1'b0;
end


endmodule

// IF/ID Register Wall
module ifid(
input clk,
input en,
input[31:0] instruction_if,
input[31:0] pcStore_if,
input[31:0] pcStore_8_if,
output reg[31:0] instruction_id,
output reg[31:0] pcStore_id,
output reg[31:0] pcStore_8_id
);
initial begin
instruction_id <= 32'b0;
pcStore_id <= 32'b0;
pcStore_8_id <= 32'b0;
end
always @(posedge clk) begin
    if(en) begin
        instruction_id <= instruction_if;
        pcStore_id <= pcStore_if;
        pcStore_8_id <= pcStore_8_if;
    end
end
endmodule

// ID/EXEC Register Wall
module idexec(
input clk,
input en,
input[197:0] idWires,
output reg[197:0] exWires
);
initial exWires <= 198'b0;
always @(posedge clk) begin
    if(en)
        exWires <= idWires;
end
endmodule

// EXEC/MEM Register Wall
module execmem(
input clk,
input en,
input[230:0] exWires,
output reg[230:0] memWires
);
initial memWires <= 231'b0;
always @(posedge clk) begin
    if(en)
        memWires <= exWires;
end
endmodule

