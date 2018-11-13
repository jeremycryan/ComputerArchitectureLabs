`include "cpu.v"

module cpu_test();

reg clk;

initial begin
    clk <= 0;
end
always begin
#1000
    clk <= ~clk;
end

cpu myCPU(clk);

initial begin
    $dumpfile("cpu.vcd");
    $dumpvars();
    #100000
    $finish();
end
endmodule
