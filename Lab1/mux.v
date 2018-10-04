`define AND and #30
`define OR or #30
`define NOT not #10

// 2 bit mux
module mux2
(
    output out,
    input in0,
    input in1,
    input sel
);

    wire mux1, mux2;
    wire selnot;

    `NOT muxNOT(selnot, sel);
    `AND muxAND1(mux1, selnot, in0);
    `AND muxAND2(mux2, sel, in1);
    `OR muxOR(out, mux1, mux2);

endmodule

// 8 bit mux
module mux8
(
    output out,
    input[7:0] ins,
    input[2:0] sel
);

    wire[7:0] selpick;	// One of these is true, corresponding to the input to forward to out
    wire ns0, ns1, ns2;
    wire s0s1, s0ns1, ns0s1, ns0ns1;    
    wire out0, out1, out2, out3, out4, out5, out6, out7;
    wire o0o1, o2o3, o4o5, o6o7, o0o1o2o3, o4o5o6o7;

    `NOT invert_sel_0 (ns0, sel[0]);   // Invert select bits for logic
    `NOT invert_sel_1 (ns1, sel[1]);
    `NOT invert_sel_2 (ns2, sel[2]);

    `AND and0 (s0s1, sel[0], sel[1]);  // Combinations of first two select bits
    `AND and1 (s0ns1, sel[0], ns1);
    `AND and2 (ns0s1, ns0, sel[1]);
    `AND and3 (ns0ns1, ns0, ns1);

    `AND and4 (selpick[0], ns0ns1, ns2);   // Determine which input to forward to out.
    `AND and5 (selpick[1], s0ns1, ns2);    // These cases should be exclusive and exhaustive.
    `AND and6 (selpick[2], ns0s1, ns2);
    `AND and7 (selpick[3], s0s1, ns2);
    `AND and8 (selpick[4], ns0ns1, sel[2]);
    `AND and9 (selpick[5], s0ns1, sel[2]);
    `AND and10 (selpick[6], ns0s1, sel[2]);
    `AND and11 (selpick[7], s0s1, sel[2]);

    `AND and12 (out0, selpick[0], ins[0]);   // If any of these "out" values are true,
    `AND and13 (out1, selpick[1], ins[1]);   // a condition has been met for a true output.
    `AND and14 (out2, selpick[2], ins[2]);
    `AND and15 (out3, selpick[3], ins[3]);
    `AND and16 (out4, selpick[4], ins[4]);
    `AND and17 (out5, selpick[5], ins[5]);
    `AND and18 (out6, selpick[6], ins[6]);
    `AND and19 (out7, selpick[7], ins[7]);

    `OR or0 (o0o1, out0, out1);   // Determine output by OR-ing them together.
    `OR or1 (o2o3, out2, out3);
    `OR or2 (o4o5, out4, out5);
    `OR or3 (o6o7, out6, out7);
    `OR or4 (o0o1o2o3, o0o1, o2o3);
    `OR or5 (o4o5o6o7, o4o5, o6o7);
    `OR output_gate (out, o0o1o2o3, o4o5o6o7);

endmodule
