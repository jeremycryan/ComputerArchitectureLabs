`define AND and #30
`define XOR xor #40
`define OR or #30

module AdderOneBit
(
    output sum, 
    output carryout,
    input a, 
    input b, 
    input carryin
);
    // Your adder code here
   wire abXOR; // output of xor with a,b as inputs
   wire abAND; // output of and with a,b as inputs
   wire cAND;  // output of and with abXOR, carryin as inputs
   
   // Define gates
   `XOR inputXOR(abXOR, a, b);
   `AND inputAND(abAND, a, b);
   `AND carryAND(cAND, abXOR, carryin);
   `XOR outXOR(sum, abXOR, carryin);
   `OR carryOR(carryout, cAND, abAND);
endmodule

module Adder32Bit
(
    output[31:0] sum, 
    output carryout,
    input[31:0] a, 
    input[31:0] b, 
    input carryin
);

    wire carryouts[31:0];

    genvar i;
    generate
        for(i=0;i<32; i=i+1)
        begin:genblock
            if(i==0)
            begin
                AdderOneBit adder(sum[i],carryouts[i],a[i],b[i],carryin);
            end
            else
            begin
                AdderOneBit adder(sum[i],carryouts[i],a[i],b[i],carryouts[i-1]);
            end
        end
    endgenerate

endmodule
