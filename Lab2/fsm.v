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
    parameter write_1 = 5
)
(
    input sclk,        // system clock
    input cs,         // chip select
    input shift_reg_out_0,
    output reg miso_buff, // miso line buffer
    output reg dm_we,     // data memory write enable
    output reg addr_we,   // address latch write enable
    output reg sr_we      // shift register write enable
);

    reg[2:0] count;
    reg[2:0] state;

    initial begin
        count = 3'b000;
        state = standby;

        miso_buff = 0;  // Initialize constants to 0
        dm_we = 0;
        addr_we = 0;
        sr_we = 0;
    end

    always @(posedge sclk) begin
        if(state == standby) begin
            miso_buff <= 0;
            dm_we <= 0;
            addr_we <= 0;
            sr_we <= 0;

            if (~cs) begin
                state <= wait_address;
                count <= 3'b000;
            end
        end

        if(state == wait_address) begin
            miso_buff <= 0;
            dm_we <= 0;
            addr_we <= 1;
            sr_we <= 0;

            if (count == 7) begin
                if shift_reg_out_0
                    state <= read_0;
                if ~shift_reg_out_0
                    state <= write_0;
                count <= 0'b000;
            end
            else
                count <= count+3'b001;
            end

        end

        if(state == read_0) begin
            miso_buff <= 0;
            dm_we <= 0;
            addr_we <= 0;
            sr_we <= 1;
            count <= 3'b000;

            state <= read_1;
        end

        if(state == read_1) begin
            miso_buff <= 1;
            dm_we <= 0;
            addr_we <= 0;
            sr_we <= 0;
            count <= count + 3'b001;

            if (count == 6) begin
                state <= standby;
            end

        end

        if(state == write_0) begin
            miso_buff <= 0;
            dm_we <= 0;
            addr_we <= 0;
            sr_we <= 0;
            count <= count + 0'b001;

            if (count == 6) begin
                state <= write_1;
            end

        end

        if(state == write_1) begin
            miso_buff <= 0;
            dm_we <= 1;
            addr_we <= 0;
            sr_we <= 0;
            count <= 0'b000;

            state <= standby;
        end
    end // end of always posedge sclk

endmodule
