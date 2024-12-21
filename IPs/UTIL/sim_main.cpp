#include "Vtop.h"       // Include your top module header
#include "verilated.h"  // Verilator library
#include "verilated_vcd_c.h"  // For VCD tracing

int main(int argc, char **argv) {
    Verilated::commandArgs(argc, argv);

    // Instantiate the top module
    Vtop *top = new Vtop;

    // Enable waveform dump
    Verilated::traceEverOn(true);
    VerilatedVcdC *vcd_trace = new VerilatedVcdC;
    top->trace(vcd_trace, 99);  // Trace levels: 99 for full detail
    vcd_trace->open("waveform.vcd");  // Output file name

    // Simulation variables
    int clk = 0;
    top->clk = 0;
    top->reset = 1;

    // Simulate for 100 clock cycles
    for (int i = 0; i < 100; ++i) {
        top->reset = (i < 10);  // Release reset after 10 cycles

        // Toggle clock
        top->clk = !top->clk;
        top->eval();
        vcd_trace->dump(i);  // Write waveform at current time
    }

    // Finalize simulation
    top->final();
    vcd_trace->close();

    // Clean up
    delete top;
    delete vcd_trace;
    return 0;
}