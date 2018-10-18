`include "fsm.v"

module fsm_test();

    reg sclk, cs, sr0;
    wire miso_buff, dm_we, addr_we, sr_we; 

    fsm finite_state (
	.sclk(sclk),
	.cs(cs),
	.shift_reg_out_0(sr0),
	.miso_buff(miso_buff),
	.dm_we(dm_we),
	.addr_we(addr_we),
	.sr_we(sr_we)	
    );

    // Set initial values of input regs
    initial begin
	sclk = 1;
	cs = 1;
	sr0 = 0;
    end

    // Run a clock with period of 10 ambiguous time units
    always begin
	#5 sclk = ~sclk;
    end

    initial begin
	$dumpfile("fsm.vcd");
	$dumpvars();

        #30 cs = 0;
	

	#1000;



	$finish();
    end

endmodule
