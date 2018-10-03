//  Extra modules for 

`define AND and #20
`define OR or #20
`define NOT not #10

`include "mux.v"

module SLTControl(
    input[2:0] sel,
    output[2:0] new_sel,
    output is_slt
);

    wire ni0, ni1, ni2;
    wire ni0ni2;
    wire nslt;

    `NOT not1 (ni0, sel[0]);
    `NOT not2 (ni1, sel[1]);
    `NOT not3 (ni2, sel[2]);    // Inverted inputs

    `AND and1 (ni0ni2, ni0, ni2);
    `AND and2 (is_slt, ni0ni2, sel[1]); // Outputs true if in SLT mode.
    `NOT not4 (nslt, is_slt);		// Outputs true if not in SLT mode.

    `OR or1 (new_sel[0], is_slt, sel[0]); // If in SLT mode, set output to 001 (subtract mode)
    `AND and3 (new_sel[1], nslt, sel[1]);
    `AND and4 (new_sel[2], nslt, sel[2]);

endmodule
