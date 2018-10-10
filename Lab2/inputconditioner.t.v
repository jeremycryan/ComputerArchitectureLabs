`include "inputconditioner.v"
//------------------------------------------------------------------------
// Input Conditioner test bench
//------------------------------------------------------------------------

module testConditioner();

    reg clk;
    reg pin;
    wire conditioned;
    wire rising;
    wire falling;
    
    inputconditioner dut(.clk(clk),
    			 .noisysignal(pin),
			 .conditioned(conditioned),
			 .positiveedge(rising),
			 .negativeedge(falling));


    // Generate clock (50MHz)
    initial clk=0;
    always #10 clk=!clk;    // 50MHz Clock
   
    initial pin=0;
    always #127 pin=!pin;  // Input Noisy Signal

    initial begin
        $dumpfile("inputconditioner.vcd");
        $dumpvars();
        #2500             // Test Length 

        $finish();
    end 
endmodule
