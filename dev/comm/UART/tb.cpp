#include <stdlib.h>
#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "obj_dir/Vtb_uart.h"

#define MAX_TIME 1000000

vluint64_t sim_time = 0;

bool tck = 0;
int tck_cnt = 0;
bool posedge = 0;

// Frame
bool frame[10];
bool frame_start;
int frame_cnt = 0;

// RX
int rx_cnt;
// Least significant first
int rx_frame0[5][11] = {{0,0,0,0,1,0,0,1,0,1,1},  // H
                        {0,1,0,1,0,0,0,1,0,0,1},  // E 
                        {0,0,0,1,1,0,0,1,0,0,1},  // L
                        {0,0,0,1,1,0,0,1,0,0,1},  // L
                        {0,1,1,1,1,0,0,1,0,0,1}}; // O
bool rx_val = 1;

void tx_eval(bool tx)
{
  int c;
  int pow;
  int even = 0;
  
  frame_start = (!tx | frame_start);

  if(frame_start){
    //printf("TX: %d\n", tx);
    frame[frame_cnt] = tx;
    frame_cnt += 1;
    if(frame_cnt == 10)
    {
      pow = 1;
      c = 0;
      for(int i = 1; i < 10; i++){
        //printf("%d",frame[i]);
        c += frame[i]*pow;
        pow = pow*2;
        even = frame[i] ^ even;
      }
      printf("TX : \"%c\"\n",c);
      if(even!=frame[8])
        printf("Frame ERROR : parity bit unmatched\n");
      frame_cnt = 0;
      frame_start = 0;
    }
  }
}
int f_idx = 0;
int i_idx = 0;
bool rx_eval()
{
  bool res = rx_frame0[f_idx][i_idx];
  i_idx += 1;
  if(i_idx == 11)
  {
    i_idx = 0;
    f_idx += 1;
    if(f_idx == 5)
      f_idx = 0;
  }
  return res;
}
void tb_uart(Vtb_uart* tb)
{
  // Receiver can always receive data
  // Test bench is faster than the simulation
  tb->cts_n = 0;

  // Send data
  tb->rx = rx_val;

  tck_cnt = tck_cnt + 1;
  if(tck_cnt >= 1302) {
    tck = !tck;
    tb->tck = tck;
    tck_cnt = 0;
    if(tck) {
      // Posedge

      // Transmitte : only if the UART is "clear to send"
      if(!tb->rts_n) {
        rx_val = rx_eval();
      } else {
        rx_val = 1;
      }
      // Receive
      tx_eval(tb->tx);
    }
  }
}

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
    tb->cts_n = 1;
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
        if(tb->clk)
          tb_uart(tb);
        tb->eval();
        m_trace->dump(sim_time);
        sim_time++;
    }

    m_trace->close();
    delete tb;
    exit(EXIT_SUCCESS);
}