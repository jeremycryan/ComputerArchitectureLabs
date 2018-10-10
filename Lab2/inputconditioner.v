//------------------------------------------------------------------------
// Input Conditioner
//    1) Synchronizes input to clock domain
//    2) Debounces input
//    3) Creates pulses at edge transitions
//------------------------------------------------------------------------

module inputconditioner
(
input 	    clk,            // Clock domain to synchronize input to
input	    noisysignal,    // (Potentially) noisy input signal
output reg  conditioned,    // Conditioned output signal
output reg  positiveedge,   // 1 clk pulse at rising edge of conditioned
output reg  negativeedge    // 1 clk pulse at falling edge of conditioned
);

    parameter counterwidth = 3; // Counter size, in bits, >= log2(waittime)
    parameter waittime = 3;     // Debounce delay, in clock cycles
    
    reg[counterwidth-1:0] counter = 0;
    reg synchronizer0 = 0;
    reg synchronizer1 = 0;

   
    always @(posedge clk ) begin
        if(conditioned == synchronizer1) begin
            counter <= 0;

            negativeedge <= 1'b0;
            positiveedge <= 1'b0; // set to low
        end
        else begin
            if( counter == waittime) begin
                counter <= 0;
                conditioned <= synchronizer1;

                negativeedge <= conditioned&~synchronizer1; // detects edges
                positiveedge <= ~conditioned&synchronizer1;
            end
            else begin
                counter <= counter+1;

                negativeedge <= 1'b0; // sets to low
                positiveedge <= 1'b0;
            end
        end
        synchronizer0 <= noisysignal;
        synchronizer1 <= synchronizer0;

    end

endmodule
