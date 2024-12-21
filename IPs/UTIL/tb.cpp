#include <stdlib.h>
#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "obj_dir/Vtb_fifo.h"

#define MAX_TIME 200000

vluint64_t sim_time = 0;

int main()
{
    Vtb_fifo* tb = new Vtb_fifo;
    Verilated::traceEverOn(true);
    VerilatedVcdC* m_trace = new VerilatedVcdC;
    tb->trace(m_trace, 5);
    m_trace->open("waveform.vcd");

    // Reset
    while(sim_time < 100)
    {
        tb->clk ^= 1;
        tb->rst_n = 0;
        tb->eval();
        m_trace->dump(sim_time);
        sim_time++;
    }

    // Normal Simulation
    while(sim_time < MAX_TIME)
    {
        tb->clk ^= 1;
        tb->rst_n = 1;
        tb->eval();
        m_trace->dump(sim_time);
        sim_time++;
    }

    m_trace->close();
    delete tb;
    exit(EXIT_SUCCESS);
}