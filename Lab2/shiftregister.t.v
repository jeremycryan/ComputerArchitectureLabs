`include "shiftregister.v"
//------------------------------------------------------------------------
// Shift Register test bench
//------------------------------------------------------------------------

module testshiftregister();

    reg             clk;
    reg             peripheralClkEdge;
    reg             parallelLoad;
    wire[7:0]       parallelDataOut;
    wire            serialDataOut;
    reg[7:0]        parallelDataIn;
    reg             serialDataIn; 
    
    // Instantiate with parameter width = 8
    shiftregister #(8) dut(.clk(clk), 
    		           .peripheralClkEdge(peripheralClkEdge),
    		           .parallelLoad(parallelLoad), 
    		           .parallelDataIn(parallelDataIn), 
    		           .serialDataIn(serialDataIn), 
    		           .parallelDataOut(parallelDataOut), 
    		           .serialDataOut(serialDataOut));
    
    // Generate clock (50MHz)
    initial clk=0;
    always #10 clk=!clk;    // 50MHz Clock

    initial peripheralClkEdge = 0;
    always #10 peripheralClkEdge = !peripheralClkEdge;
 
    initial begin
        $dumpfile("shiftregister.vcd");
        $dumpvars();
        // Testing Parallel Data In Serial Data Out
        assign serialDataIn=1'b0;
        assign parallelLoad=1'b1;
        assign parallelDataIn = 8'hA5;
        #25
        assign parallelLoad=1'b0;
        #150

        // Testing Serial Data In Parallel Data Out
        assign serialDataIn=1'b1;
        #60
        assign serialDataIn=1'b0;
        #200

        $finish();

    end

endmodule

