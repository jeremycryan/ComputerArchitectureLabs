module dflipflop
(
    output q,
    input d,
    input en,
    input clk
);

    // Assign D to Q at positive clock edge,
    // if enable is true.
    always @(posedge clk) begin
        if en begin
            q <= d;
        end
    end

endmodule
