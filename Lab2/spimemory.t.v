`include "spimemory.v"

module spi_test();

    // Spi inputs
    reg clk, sclk_pin, cs_pin, mosi_pin;
    wire miso_pin;
    wire[3:0] leds; 
    
    // Instantiate spi module
    spiMemory spi (
	.clk(clk),
	.sclk_pin(sclk_pin),
	.cs_pin(cs_pin),
	.miso_pin(miso_pin),
	.mosi_pin(mosi_pin),
	.leds(leds)
    );

    // Set initial values for test bench registers
    initial begin
	clk = 0;
	sclk_pin = 0;
	cs_pin = 1;
	mosi_pin = 0;
    end

    // Run clock with period 10 ambiguous time units
    always begin
	#5 clk = ~clk;
    end
    
    // Test the bench
    initial begin
	$dumpfile("spimemory.vcd");
	$dumpvars();

	#100;



	$finish();
    end

endmodule
