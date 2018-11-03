// Single-bit D Flip-Flop with enable
//   Positive edge triggered
module register
(
output reg	q,
input		d,
input		wrenable,
input		clk
);

    always @(posedge clk) begin
        if(wrenable) begin
            q <= d;
        end
    end

endmodule

// Module for 32 bit register
module register32
(
output [31:0] q,
input[31:0] d,
input wrenable,
input clk
);

genvar i;
generate
    for(i=0; i < 32; i=i+1)begin
        register registerBit(q[i],d[i],wrenable,clk);  // sets each of the register's bits
    end
endgenerate

endmodule

// Module for 32 bit register with all zeros
module register32zero(
output [31:0] q,
input[31:0] d,
input wrenable,
input clk
);

genvar i;
generate
    for(i=0; i< 32; i=i+1)begin
        assign q[i] = 1'b0;  // sets all registers to 0
    end
endgenerate

endmodule
