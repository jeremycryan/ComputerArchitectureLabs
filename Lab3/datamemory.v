//------------------------------------------------------------------------
// Data Memory
//   Positive edge triggered
//   dataOut always has the value mem[address]
//   If writeEnable is true, writes dataIn to mem[address]
//------------------------------------------------------------------------

module datamemory
#(
    parameter addresswidth  = 28,
    parameter depth         = 2**addresswidth,
    parameter width         = 8 
)
(
    input 		                clk,
    output [(4*width)-1:0]      dataOut,
    input [addresswidth-1:0]    address,
    input                       writeEnable,
    input [(4*width)-1:0]       dataIn
);


    reg [width-1:0] memory [depth-1:0];

    always @(posedge clk) begin
        if(writeEnable)begin
            memory[address] <= dataIn[31:24];
            memory[address+1] <= dataIn[23:16];
            memory[address+2] <= dataIn[15:8];
            memory[address+3] <= dataIn[7:0];
        end


    end

    initial $readmemh(“file.dat”, memory);

    assign dataOut = {memory[address], 
                  memory[address+1],
                  memory[address+2],
                  memory[address+3]};
endmodule
