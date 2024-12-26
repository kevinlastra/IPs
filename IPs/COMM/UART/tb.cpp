#include <stdlib.h>
#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "obj_dir/Vtb_uart.h"

#define MAX_TIME 2000000

vluint64_t sim_time = 0;

int main()
{
    Vtb_uart* tb = new Vtb_uart;
    Verilated::traceEverOn(true);
    VerilatedVcdC* m_trace = new VerilatedVcdC;
    tb->trace(m_trace, 5);
    m_trace->open("waveform.vcd");

    // Init
    tb->clk ^= 1;
    tb->rst_n = 1;
    tb->eval();
    m_trace->dump(sim_time);
    sim_time++;

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