//-----------------------------------------------------------------------
// Finite State Machine
//-----------------------------------------------------------------------


module fsm
#(
    parameter standby = 0,
    parameter wait_address = 1,
    parameter read_0 = 2,
    parameter read_1 = 3,
    parameter write_0 = 4,
    parameter write_1 = 5,
    parameter wait_end = 6,
    parameter check_mosi = 7
)
(
    input clk,        // system clock
    input sclk,	      // serial clock
    input cs,         // chip select
    input shift_reg_out_0,
    output reg miso_buff, // miso line buffer
    output reg dm_we,     // data memory write enable
    output reg addr_we,   // address latch write enable
    output reg sr_we      // shift register write enable
);

    reg[3:0] count;
    reg[2:0] state;

    initial begin
        count = 4'b0000;
        state = standby;

        miso_buff = 0;  // Initialize constants to 0
        dm_we = 0;
        addr_we = 0;
        sr_we = 0;
    end

    always @(posedge clk) begin 
        if(state == standby) begin


            if (~cs) begin
                state <= wait_address;
                count <= 4'b0000;
                miso_buff <= 0;
                dm_we <= 0;
                addr_we <= 1;
                sr_we <= 0;
            end
        end

        if(state == wait_address) begin
            if (count == 7) begin
	    	if (sclk)
		    state <= check_mosi;
	    end

            else begin
		if(sclk)
                    count <= count+3'b001;
            end

        end

	if(state == check_mosi) begin
                    if(shift_reg_out_0) begin
                        miso_buff <= 1;
                        dm_we <= 0;
                        addr_we <= 0;
                        sr_we <= 0;
                        count <= 4'b0000;

                        state <= read_0;
			count <= 4'b0000;
		    end
	
		if (sclk) begin
                    if(~shift_reg_out_0) begin
                        miso_buff <= 0;
                        dm_we <= 0;
                        addr_we <= 0;
                        sr_we <= 0;

                        state <= write_0;
			count <= 4'b0000;
		    end
                end

   	    
	end

        if(state == read_1) begin

	    if (sclk)
                count <= count + 4'b0001;

            if (count == 8) begin
                state <= wait_end;
                miso_buff <= 0;
                dm_we <= 0;
                addr_we <= 0;
                
            end

	    sr_we <= 0;
        end

        if(state == write_0) begin
            
	    if (sclk)
	        count <= count + 4'b0001;

            if (count == 7) begin
                miso_buff <= 0;
                dm_we <= 1;
                addr_we <= 0;
                sr_we <= 0;

                state <= write_1;
            end

        end

        if(state == write_1) begin
            count <= 4'b0000;

            state <= wait_end;
            miso_buff <= 0;
            dm_we <= 0;
            addr_we <= 0;
            sr_we <= 0;
        end

        if(state == read_0) begin
            miso_buff <= 1;
            dm_we <= 0;
            addr_we <= 0;
            sr_we <= 1;
            state <= read_1;
        end


        if(state == wait_end) begin
            if(cs==1) begin
                state <= standby;
            end
        end
 
    end // end of always posedge sclk

endmodule
