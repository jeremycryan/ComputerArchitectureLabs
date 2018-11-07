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

module mux2_32
(
    output[31:0] out,
    input[31:0] in0,
    input[31:0] in1,
    input sel
);

    wire mux1, mux2;
    wire selnot;

    genvar i;
    generate
    for(i=0;i<32;i=i+1)begin
        mux2 muxy(out[i],in0[i],in1[i],sel);
    end
    endgenerate
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

module mux32to1by1
(
        output      out,
        input[4:0]  address,
        input[31:0] inputs
);
  // Your code
  assign out = inputs[address];
endmodule

module mux32to1by32
(
        output[31:0]  out,
        input[4:0]    address,
        input[31:0]   input0, input1, input2,input3, input4,input5,input6,input7,input8,input9,input10,input11,input12,input13,input14,input15,input16,input17,input18,input19,input20,input21,input22,input23,input24,input25,input26,input27,input28,input29,input30,input31
);
// Assigns all 32 32-bit muxen
    wire[31:0] mux[31:0];       // Create a 2D array of wires
    assign mux[0] = input0;     // Connect the sources of the array
    assign mux[1] = input1;     // Connect the sources of the array
    assign mux[2] = input2;     // Connect the sources of the array
    assign mux[3] = input3;     // Connect the sources of the array
    assign mux[4] = input4;     // Connect the sources of the array
    assign mux[5] = input5;     // Connect the sources of the array
    assign mux[6] = input6;     // Connect the sources of the array
    assign mux[7] = input7;     // Connect the sources of the array
    assign mux[8] = input8;     // Connect the sources of the array
    assign mux[9] = input9;     // Connect the sources of the array
    assign mux[10] = input10;     // Connect the sources of the array
    assign mux[11] = input11;     // Connect the sources of the array
    assign mux[12] = input12;     // Connect the sources of the array
    assign mux[13] = input13;     // Connect the sources of the array
    assign mux[14] = input14;     // Connect the sources of the array
    assign mux[15] = input15;     // Connect the sources of the array
    assign mux[16] = input16;     // Connect the sources of the array
    assign mux[17] = input17;     // Connect the sources of the array
    assign mux[18] = input18;     // Connect the sources of the array
    assign mux[19] = input19;     // Connect the sources of the array
    assign mux[20] = input20;     // Connect the sources of the array
    assign mux[21] = input21;     // Connect the sources of the array
    assign mux[22] = input22;     // Connect the sources of the array
    assign mux[23] = input23;     // Connect the sources of the array
    assign mux[24] = input24;     // Connect the sources of the array
    assign mux[25] = input25;     // Connect the sources of the array
    assign mux[26] = input26;     // Connect the sources of the array
    assign mux[27] = input27;     // Connect the sources of the array
    assign mux[28] = input28;     // Connect the sources of the array
    assign mux[29] = input29;     // Connect the sources of the array
    assign mux[30] = input30;     // Connect the sources of the array
    assign mux[31] = input31;     // Connect the sources of the array

    assign out = mux[address];   // Connect the output of the array
endmodule
