#include <stdlib.h>
#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "obj_dir/Vtb.h"

#define MAX_TIME 20000

vluint64_t sim_time = 0;

int main()
{
    Vtb* dut = new Vtb;
    Verilated::traceEverOn(true);
    VerilatedVcdC* m_trace = new VerilatedVcdC;
    dut->trace(m_trace, 5);
    m_trace->open("waveform.vcd");

    // Reset
    while(sim_time < 100)
    {
        dut->clk ^= 1;
        dut->rst_n = 0;
        dut->eval();
        m_trace->dump(sim_time);
        sim_time++;
    }

    // Normal Simulation
    while(sim_time < MAX_TIME)
    {
        dut->clk ^= 1;
        dut->rst_n = 1;
        dut->eval();
        m_trace->dump(sim_time);
        sim_time++;
    }

    m_trace->close();
    delete dut;
    exit(EXIT_SUCCESS);
}