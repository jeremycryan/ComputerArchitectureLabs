`timescale 1ns / 1ps
`include "alu.v"

module testALU1Bit();
    reg a;
    reg b;
    reg carryin;
    reg[2:0] control;

    wire carryout;
    wire out;

    ALUOneBit alu(out,carryout,a,b,carryin,control);
    
    initial begin
        $display(" A   B   Ci  |  Out Co ");
        a=1;b=1;carryin=0;control=3'b000; #1000;
        $display(" %b   %b   %b  |  %b   %b ", a,b,carryin,out,carryout);
        a=1;b=1;carryin=1;control=3'b001; #1000;
        $display(" %b   %b   %b  |  %b   %b ", a,b,carryin,out,carryout);
    end
endmodule
