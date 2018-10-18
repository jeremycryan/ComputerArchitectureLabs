`include "flips.v"

module latch
#(
        parameter width = 7     // input/output width
)
(
        output [width-1:0] q,    
        input[width-1:0] d,
        input en,
        input clk
);

    genvar i;
    generate    // generate an array of N flipflops
        for (i=0; i<width; i=i+1) begin
            dflipflop dff (
                    .q(q[i]),
                    .d(d[i]),
                    .en(en),
                    .clk(clk)
            );
        end
    endgenerate

endmodule
