// 32-bit ALU test bench

`include "alu.v"

module testALU32();
    reg[31:0] a;    // Item 1
    reg[31:0] b;    // Item 2
    reg[2:0] sel;   // Function select
    
    wire[31:0] out;
    wire carryout, zero, overflow;

    ALU32Bit alu (out, carryout, overflow, zero, a, b, sel);

    initial begin

        $display(" ---------------A---------------- | ---------------B---------------- | SEL | --------------OUT--------------- | CO ZR OF");

    assign a = 32'b00000000000000000010000000000001;
    assign b = 32'b00000000000000000000000000000001;
    assign sel = 3'b000;
    #5000
    $display(" %b | %b | %b | %b |  %b  %b  %b ", a, b, sel, out, carryout, zero, overflow);
       
    assign sel = 3'b001;
    #5000
    $display(" %b | %b | %b | %b |  %b  %b  %b ", a, b, sel, out, carryout, zero, overflow);
        
	assign sel = 3'b010;
    #5000
    $display(" %b | %b | %b | %b |  %b  %b  %b ", a, b, sel, out, carryout, zero, overflow);

	assign sel = 3'b011;
    #5000
	$display(" %b | %b | %b | %b |  %b  %b  %b ", a, b, sel, out, carryout, zero, overflow);
	
	assign sel = 3'b100;
    #5000
	$display(" %b | %b | %b | %b |  %b  %b  %b ", a, b, sel, out, carryout, zero, overflow);

	assign sel = 3'b101;
    #5000
	$display(" %b | %b | %b | %b |  %b  %b  %b ", a, b, sel, out, carryout, zero, overflow);

	assign sel = 3'b110;
    #5000
	$display(" %b | %b | %b | %b |  %b  %b  %b ", a, b, sel, out, carryout, zero, overflow);

	assign sel = 3'b111;
    #5000
	$display(" %b | %b | %b | %b |  %b  %b  %b ", a, b, sel, out, carryout, zero, overflow);

    $display("-------------------------------------------------------------------------------");
// ----------------------------------------------------------------------------------------------

    assign a = 32'b10000000000000000000000000000001;
    assign b = 32'b00000000000000000000000000000001;
    assign sel = 3'b000;
    #5000
    $display(" %b | %b | %b | %b |  %b  %b  %b ", a, b, sel, out, carryout, zero, overflow);
       
    assign sel = 3'b001;
    #5000
    $display(" %b | %b | %b | %b |  %b  %b  %b ", a, b, sel, out, carryout, zero, overflow);
        
	assign sel = 3'b010;
    #5000
    $display(" %b | %b | %b | %b |  %b  %b  %b ", a, b, sel, out, carryout, zero, overflow);

	assign sel = 3'b011;
    #5000
	$display(" %b | %b | %b | %b |  %b  %b  %b ", a, b, sel, out, carryout, zero, overflow);
	
	assign sel = 3'b100;
    #5000
	$display(" %b | %b | %b | %b |  %b  %b  %b ", a, b, sel, out, carryout, zero, overflow);

	assign sel = 3'b101;
    #5000
	$display(" %b | %b | %b | %b |  %b  %b  %b ", a, b, sel, out, carryout, zero, overflow);

	assign sel = 3'b110;
    #5000
	$display(" %b | %b | %b | %b |  %b  %b  %b ", a, b, sel, out, carryout, zero, overflow);

	assign sel = 3'b111;
    #5000
	$display(" %b | %b | %b | %b |  %b  %b  %b ", a, b, sel, out, carryout, zero, overflow);

    assign a = 32'b00000000000000000010000000000001;
    assign b = 32'b00000000000000000000000000000001;
    assign sel = 3'b000;
    #5000
    $display(" %b | %b | %b | %b |  %b  %b  %b ", a, b, sel, out, carryout, zero, overflow);
       
    assign sel = 3'b001;
    #5000
    $display(" %b | %b | %b | %b |  %b  %b  %b ", a, b, sel, out, carryout, zero, overflow);
        
	assign sel = 3'b010;
    #5000
    $display(" %b | %b | %b | %b |  %b  %b  %b ", a, b, sel, out, carryout, zero, overflow);

	assign sel = 3'b011;
    #5000
	$display(" %b | %b | %b | %b |  %b  %b  %b ", a, b, sel, out, carryout, zero, overflow);
	
	assign sel = 3'b100;
    #5000
	$display(" %b | %b | %b | %b |  %b  %b  %b ", a, b, sel, out, carryout, zero, overflow);

	assign sel = 3'b101;
    #5000
	$display(" %b | %b | %b | %b |  %b  %b  %b ", a, b, sel, out, carryout, zero, overflow);

	assign sel = 3'b110;
    #5000
	$display(" %b | %b | %b | %b |  %b  %b  %b ", a, b, sel, out, carryout, zero, overflow);

	assign sel = 3'b111;
    #5000
	$display(" %b | %b | %b | %b |  %b  %b  %b ", a, b, sel, out, carryout, zero, overflow);

    assign a = 32'b00000000000000000010000000000001;
    assign b = 32'b00000000000000000000000000000001;
    assign sel = 3'b000;
    #5000
    $display(" %b | %b | %b | %b |  %b  %b  %b ", a, b, sel, out, carryout, zero, overflow);
       
    assign sel = 3'b001;
    #5000
    $display(" %b | %b | %b | %b |  %b  %b  %b ", a, b, sel, out, carryout, zero, overflow);
        
	assign sel = 3'b010;
    #5000
    $display(" %b | %b | %b | %b |  %b  %b  %b ", a, b, sel, out, carryout, zero, overflow);

	assign sel = 3'b011;
    #5000
	$display(" %b | %b | %b | %b |  %b  %b  %b ", a, b, sel, out, carryout, zero, overflow);
	
	assign sel = 3'b100;
    #5000
	$display(" %b | %b | %b | %b |  %b  %b  %b ", a, b, sel, out, carryout, zero, overflow);

	assign sel = 3'b101;
    #5000
	$display(" %b | %b | %b | %b |  %b  %b  %b ", a, b, sel, out, carryout, zero, overflow);

	assign sel = 3'b110;
    #5000
	$display(" %b | %b | %b | %b |  %b  %b  %b ", a, b, sel, out, carryout, zero, overflow);

	assign sel = 3'b111;
    #5000
	$display(" %b | %b | %b | %b |  %b  %b  %b ", a, b, sel, out, carryout, zero, overflow);

    end
endmodule
