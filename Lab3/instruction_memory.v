//------------------------------------------------------------------------
// Instruction Memory
//   Positive edge triggered
//   dataOut always has the value mem[address]
//   If writeEnable is true, writes dataIn to mem[address]
//------------------------------------------------------------------------

module instruction_memory
#(
    parameter addresswidth  = 32,
    // limiting datamemory depth because otherwise icarus verilog
    // won't compile it
    parameter depth         = 2**(20),
    parameter width         = 8 
)(
    input 			clk,
    output [4*width-1:0]      dataOut,
    input [addresswidth-1:0]    address
);


    reg [width-1:0] memory [depth-1:0];

    initial begin
        $readmemh("test_program_0.mem", memory);
    end

    assign dataOut = {memory[address], 
                  memory[address+1],
                  memory[address+2],
                  memory[address+3]};
endmodule
