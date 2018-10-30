// 16 -> 32 sign extender module.

module signExtend1632 (
    output[31:0] out32,
    input[15:0] in16
);

    // Assign least significant outputs to inputs
    assign out32[15:0] = in16;
    
    // Assign all other outputs to most significant input
    genvar i;
        generate for (i=0; i<16; i=i+1) begin
            assign out32[16+i] = in16[15];
        end
    endgenerate

endmodule
