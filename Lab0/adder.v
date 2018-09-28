// Adder circuit, made by Nathaniel for HW2.
`define AND and #50
`define XOR xor #50
`define OR or #50
module behavioralFullAdder
(
    output sum, 
    output carryout,
    input a, 
    input b, 
    input carryin
);
    // Uses concatenation operator and built-in '+'
    assign {carryout, sum}=a+b+carryin;
endmodule

module adder_onebit
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
