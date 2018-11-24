// 8-input mux testbench
`timescale 1 ns / 1 ps
`include "mux.v"

module testFullAdder();
    reg[7:0] ins;
    reg[2:0] sel;
    wire out;
    integer i;    

    mux8 test_mux (out, ins, sel);

    initial begin
        $display("   INPUT | SEL | OUT");
        
        //integer error = 0;

        
        ins = 8'b0000100;
        sel = 3'b010;
        #1000;

        $display("%b | %b |   %b", ins, sel, out);
       

        ins = 8'b0000100;
        sel = 3'b011;
	#1000;
        $display("%b | %b |   %b", ins, sel, out);

        ins = 8'b11111111;
        sel = 3'b111;
	#1000;
        $display("%b | %b |   %b", ins, sel, out);

        ins = 8'b01111111;
        sel = 3'b111;
	#1000;
        $display("%b | %b |   %b", ins, sel, out);


    end
endmodule
