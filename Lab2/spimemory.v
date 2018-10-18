//------------------------------------------------------------------------
// SPI Memory
//------------------------------------------------------------------------

`include "inputconditioner.v"
`include "shiftregister.v"
`include "latch.v"
`include "flips.v"
`include "fsm.v"
`include "datamemory.v"

module spiMemory
#(

)
(
    input           clk,        // FPGA clock
    input           sclk_pin,   // SPI clock
    input           cs_pin,     // SPI chip select
    output          miso_pin,   // SPI master in slave out
    input           mosi_pin,   // SPI master out slave in
    output [3:0]    leds        // LEDs for debugging
);

// Data Memory Wires
wire shift_reg_out_s;
wire[7:0] shift_reg_out_p;
wire[6:0] data_address;
wire[7:0] data_out;

// Input Conditioner Wires
wire serial_in, shift_reg_sclk, dff_ce, fsm_cs;

// Finite State Machine Wires
wire miso_buff, dm_we, addr_we, sr_we;

// D-flip flop wires
wire q;


reg[2:0] counter;

datamemory data(clk, data_out, data_address, dm_we, shift_reg_out_p);

// Input Conditioners
inputconditioner mosi(
                 .clk(clk),
                 .noisysignal(mosi_pin),
                 .conditioned(serial_in),
                 .positiveedge(),
                 .negativeedge()
);

inputconditioner sclk(
                .clk(clk),
                .noisysignal(sclk_pin),
                .conditioned(),
                .positiveedge(shift_reg_sclk),
                .negativeedge(dff_ce)
);

inputconditioner cs(
                .clk(clk),
                .noisysignal(cs_pin),
                .conditioned(fsm_cs),
                .positiveedge(),
                .negativeedge()
);

// Shift Register
shiftregister shifty(
                .clk(clk),
                .peripheralClkEdge(shift_reg_sclk),
                .parallelLoad(sr_we),
                .parallelDataIn(data_out),
                .serialDataIn(serial_in),
                .parallelDataOut(shift_reg_out_p),
                .serialDataOut(shift_reg_out_s)
);

// MISO D Flip Flop
dflipflop flippy(
                .q(q),
                .d(shift_reg_out_s),
                .en(dff_ce),
                .clk(clk)
);

// Finite State Machine
fsm statey(
                .sclk(sclk_pin),
                .cs(cs_pin),
                .shift_reg_out_0(shift_reg_out_p[0]),
                .miso_buff(miso_buff),
                .dm_we(dm_we),
                .addr_we(addr_we),
                .sr_we(sr_we)
);

// Address Latch
latch latchy(
                .q(data_address),
                .d(shift_reg_out_p),
                .en(addr_we),
                .clk(clk)
);
always @(posedge clk) begin
    
endmodule
   
