`include "inputconditioner.v"
`include "shiftregister.v"

module midpoint
(
input clk,
input [0:0] btn,
input[2:0] sw,
output reg [3:0] led
);

wire parallelLoad;
wire serialIn;
wire clkEdge;

wire[7:0] outputLEDs;

always @(posedge clk) begin
        if (sw[2] == 0) begin
                led <= outputLEDs[3:0];
        end else begin
                led <= outputLEDs[7:4];
        end
end

inputconditioner inputcon1(
        .clk(clk),
        .noisysignal(btn[0]),
        .conditioned(),
        .positiveedge(),
        .negativeedge(parallelLoad)
);

inputconditioner inputcon2(
        .clk(clk),
        .noisysignal(sw[0]),
        .conditioned(serialIn),
        .positiveedge(),
        .negativeedge()
);

inputconditioner inputcon3(
        .clk(clk),
        .noisysignal(sw[1]),
        .conditioned(),
        .positiveedge(clkEdge),
        .negativeedge()
);

shiftregister shifty(
        .clk(clk),
        .peripheralClkEdge(clkEdge),
        .parallelLoad(parallelLoad),
        .parallelDataIn('hA5),
        .serialDataIn(serialIn),
        .parallelDataOut(outputLEDs),
        .serialDataOut()
);

endmodule
