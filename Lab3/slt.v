//  Extra modules for 

`define AND and #30
`define OR or #30
`define NOT not #10

`include "mux.v"

module SLTControl( // Alters control signal if slt is selected
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

module SLTinator(  // turns outputs from non-slt alu into slt output if is_slt is true
    input[31:0] ins,
    input is_slt,
    output[31:0] outs
);
    wire nis_slt;

    `NOT nis(nis_slt, is_slt);

    genvar i;
    generate
        for(i=0; i<32; i=i+1)
        begin:genblock
           if(i==0) // Special case for bit 0
           begin
                mux2 mux(outs[0], ins[0], ins[31], is_slt);
           end
           else
           begin
                `AND sltSel(outs[i],ins[i],nis_slt);
           end
        end
    endgenerate
endmodule
