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
	clk = 1;
	sclk_pin = 1;
	cs_pin = 1;
	mosi_pin = 0;
    end

    // Two addresses to test read and write
    reg[6:0] test_addr_1;
    reg[6:0] test_addr_2;
    
    // Data chunks to write
    reg[7:0] test_write_1;
    reg[7:0] test_write_2;

    // Run clock with period 10 ambiguous time units
    always begin
	#1 clk = ~clk;
    end

    // Run system clock with period of 40 atus
    always begin
	#20 sclk_pin = ~sclk_pin;
    end
    
    integer i;

    // Test the bench
    initial begin
	$dumpfile("spimemory.vcd");
	$dumpvars();

	// Set some addresses to test
	test_addr_1 = 7'b0000011;//7'b0010110;
        test_addr_2 = 7'b1101111;

	// Set some writes to test
	test_write_1 = 8'b10101010;//8'b11110000;
	test_write_2 = 8'b10101010;

	///////////////////////// TEST WRITE /////////////////////

	#100;
        cs_pin = 0;

	// Input address serially
	for (i=6; i>-1; i=i-1) begin
	    mosi_pin = test_addr_1[i]; #40;
	end

	// Test write
	mosi_pin = 0;

	// Input address serially
	for (i=7; i>-1; i=i-1) begin
	    #40 mosi_pin = test_write_1[i];
	end

	// set chip select high again
        #80 cs_pin = 1;

	#80

	/////////////////////// TEST READ ////////////////////////

	#120;
	cs_pin = 0;

	// Input address serially
	for (i=6; i>-1; i=i-1) begin
	    mosi_pin = test_addr_1[i]; #40;
	end

	// Test read
	mosi_pin = 1;

	// Input data serially except not really we're in read mode
	for (i=7; i>-1; i=i-1) begin
	    #40 mosi_pin = 0;
	end

	#80 cs_pin = 1;

	#80

	$finish();
    end

endmodule
