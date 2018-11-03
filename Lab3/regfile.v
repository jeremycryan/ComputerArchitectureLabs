`include "decoders.v"
`include "mux.v"
`include "register.v"
//------------------------------------------------------------------------------
// MIPS register file
//   width: 32 bits
//   depth: 32 words (reg[0] is static zero register)
//   2 asynchronous read ports
//   1 synchronous, positive edge triggered write port
//------------------------------------------------------------------------------

module regfile
(
output[31:0]	ReadData1,	// Contents of first register read
output[31:0]	ReadData2,	// Contents of second register read
input[31:0]	WriteData,	// Contents to write to register
input[4:0]	ReadRegister1,	// Address of first register to read
input[4:0]	ReadRegister2,	// Address of second register to read
input[4:0]	WriteRegister,	// Address of register to write
input		RegWrite,	// Enable writing of register when High
input		Clk		// Clock (Positive Edge Triggered)
);

  wire[31:0] registersOut [31:0];
  wire[31:0] enables;
 
  // Decoder enables the right register for writing
  decoder1to32 decode(enables, RegWrite, WriteRegister);

  // Zero Register
  // I let the input port (d) just float, not sure if this is best practice or not
  register32zero zeros(.q(registersOut[0]),.d(),.wrenable(enables[0]),.clk(Clk));
  generate

  genvar i;

  //Generates the remaining 31 non-zero registers
  for (i=0;i<31;i=i+1)begin
    register32 registers(
    .q(registersOut[i+1]),
    .d(WriteData),
    .wrenable(enables[i+1]),
    .clk(Clk)
    );
  end
  endgenerate

  // Mux the registers based on read address
  mux32to1by32 mux0(ReadData1, ReadRegister1, registersOut[0],registersOut[1],registersOut[2],registersOut[3],registersOut[4],registersOut[5],registersOut[6],registersOut[7],registersOut[8],registersOut[9],registersOut[10],registersOut[11],registersOut[12],registersOut[13],registersOut[14],registersOut[15],registersOut[16],registersOut[17],registersOut[18],registersOut[19],registersOut[20],registersOut[21],registersOut[22],registersOut[23],registersOut[24],registersOut[25],registersOut[26],registersOut[27],registersOut[28],registersOut[29],registersOut[30],registersOut[31]);
  
  mux32to1by32 mux1(ReadData2, ReadRegister2, registersOut[0],registersOut[1],registersOut[2],registersOut[3],registersOut[4],registersOut[5],registersOut[6],registersOut[7],registersOut[8],registersOut[9],registersOut[10],registersOut[11],registersOut[12],registersOut[13],registersOut[14],registersOut[15],registersOut[16],registersOut[17],registersOut[18],registersOut[19],registersOut[20],registersOut[21],registersOut[22],registersOut[23],registersOut[24],registersOut[25],registersOut[26],registersOut[27],registersOut[28],registersOut[29],registersOut[30],registersOut[31]);
endmodule
