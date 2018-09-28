`timescale 1ns / 1ps
`include "adder_4bit.v"

module testAdder4Bit ();
    reg[3:0] a;
    reg[3:0] b;

    wire carryout;
    wire[3:0] sum;
    wire overflow;

    integer i;
    integer j;

    FullAdder4bit adder (sum, carryout, overflow, a, b);
    
    initial begin
        $display(" A3 A2 A1 A0 | B3 B2 B1 B0 | S3 S2 S1 S0 | Co Ov ");
        // Exhaustive test cases
//        for (i=0; i<16; i=i+1) begin
            
//           a[0] = i%2;
//            a[1] = i/2%2;
//            a[2] = i/4%2;
//            a[3] = i/8%2;

//            for (j=0; j<16; j=j+1) begin
//                b[0] = j%2;
//                b[1] = j/2%2;
//                b[2] = j/4%2;
//                b[3] = j/8%2;                                

//                #500;

//                $display("  %b  %b  %b  %b |  %b  %b  %b  %b |  %b  %b  %b  %b |  %b  %b", a[3], a[2], a[1], a[0], b[3], b[2], b[1], b[0], sum[3], sum[2], sum[1], sum[0], carryout, overflow);

 //           end
 //       end
 //       specific test cases
        a = 4'b0010;b = 4'b0100; #1000;
        $display("  %b  %b  %b  %b |  %b  %b  %b  %b |  %b  %b  %b  %b |  %b  %b", a[3], a[2], a[1], a[0], b[3], b[2], b[1], b[0], sum[3], sum[2], sum[1], sum[0], carryout, overflow);
        $display("                   Expected:  0  1  1  0 |  0  0");

        a = 4'b0011;b = 4'b0010; #1000;
        $display("  %b  %b  %b  %b |  %b  %b  %b  %b |  %b  %b  %b  %b |  %b  %b", a[3], a[2], a[1], a[0], b[3], b[2], b[1], b[0], sum[3], sum[2], sum[1], sum[0], carryout, overflow);
        $display("                   Expected:  0  1  0  1 |  0  0");
 
        $display("Test Carry Out:");
        a = 4'b1010;b = 4'b0101; #1000;
        $display("  %b  %b  %b  %b |  %b  %b  %b  %b |  %b  %b  %b  %b |  %b  %b", a[3], a[2], a[1], a[0], b[3], b[2], b[1], b[0], sum[3], sum[2], sum[1], sum[0], carryout, overflow);
        $display("                   Expected:  1  1  1  1 |  0  0");
 
        a = 4'b1111;b = 4'b0100; #1000;
        $display("  %b  %b  %b  %b |  %b  %b  %b  %b |  %b  %b  %b  %b |  %b  %b", a[3], a[2], a[1], a[0], b[3], b[2], b[1], b[0], sum[3], sum[2], sum[1], sum[0], carryout, overflow);
        $display("                   Expected:  0  0  1  1 |  1  0");

        $display("Test Overflow:"); 
        a = 4'b0101;b = 4'b0111; #1000;
        $display("  %b  %b  %b  %b |  %b  %b  %b  %b |  %b  %b  %b  %b |  %b  %b", a[3], a[2], a[1], a[0], b[3], b[2], b[1], b[0], sum[3], sum[2], sum[1], sum[0], carryout, overflow);
        $display("                   Expected:  1  1  0  0 |  0  1");
 
        a = 4'b1101;b = 4'b1001; #1000;
        $display("  %b  %b  %b  %b |  %b  %b  %b  %b |  %b  %b  %b  %b |  %b  %b", a[3], a[2], a[1], a[0], b[3], b[2], b[1], b[0], sum[3], sum[2], sum[1], sum[0], carryout, overflow);
        $display("                   Expected:  0  1  1  0 |  1  1");
 
    end
endmodule
