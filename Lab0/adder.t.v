// Adder testbench, made by Jeremy for HW2
`timescale 1 ns / 1 ps
`include "adder.v"

module testFullAdder();
    reg a, b, carryin;
    wire sum, carryout;
    wire my_sum, my_carryout;
    integer i;    

    behavioralFullAdder adder (sum, carryout, a, b, carryin);
    structuralFullAdder my_adder (my_sum, my_carryout, a, b, carryin);

    initial begin
        $dumpfile("adder.vcd");
        $dumpvars();
        $display(" A B Cin | Ben's: SUM Cout | My: SUM Cout");
        for (i=0; i<8; i=i+1) begin
            
            a=i%2;
            b=i/2%2;
            carryin=i/4%2;
            #500;

            $display(" %b %b %b   |          %b    %b |       %b    %b", a, b, carryin, sum, carryout, my_sum, my_carryout);
        end
        $finish();
    end
endmodule
