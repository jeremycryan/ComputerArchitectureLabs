module dflipflop
(
    output q,
    input d,
    input en,
    input clk
);

    reg out;
    assign q = out;

    // Assign D to Q at positive clock edge,
    // if enable is true.
    always @(posedge clk) begin
        if(en) begin
            out <= d;
        end
    end

endmodule
