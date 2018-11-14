`include "cpu.v"

module cpu_test();

// Initialize clock register
reg clk;
initial begin
    clk <= 0;
end

// Run clock
always begin
    #10000
    clk <= ~clk;
end

// Instantiate processor module
cpu myCPU(clk);

// Run processor for 500k arbitrary time units.
// The program being executed is dependent on
// what hex file is being loaded into the
// instruction_memory module.
initial begin

    // Dump files to analyze in GTKWave
    $dumpfile("cpu.vcd");
    $dumpvars();

    // Run for a while
    #500000
    $finish();
end
endmodule
