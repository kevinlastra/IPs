// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vtb_fifo__Syms.h"


//======================

void Vtb_fifo::trace(VerilatedVcdC* tfp, int, int) {
    tfp->spTrace()->addInitCb(&traceInit, __VlSymsp);
    traceRegister(tfp->spTrace());
}

void Vtb_fifo::traceInit(void* userp, VerilatedVcd* tracep, uint32_t code) {
    // Callback from tracep->open()
    Vtb_fifo__Syms* __restrict vlSymsp = static_cast<Vtb_fifo__Syms*>(userp);
    if (!Verilated::calcUnusedSigs()) {
        VL_FATAL_MT(__FILE__, __LINE__, __FILE__,
                        "Turning on wave traces requires Verilated::traceEverOn(true) call before time 0.");
    }
    vlSymsp->__Vm_baseCode = code;
    tracep->module(vlSymsp->name());
    tracep->scopeEscape(' ');
    Vtb_fifo::traceInitTop(vlSymsp, tracep);
    tracep->scopeEscape('.');
}

//======================


void Vtb_fifo::traceInitTop(void* userp, VerilatedVcd* tracep) {
    Vtb_fifo__Syms* __restrict vlSymsp = static_cast<Vtb_fifo__Syms*>(userp);
    Vtb_fifo* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    {
        vlTOPp->traceInitSub0(userp, tracep);
    }
}

void Vtb_fifo::traceInitSub0(void* userp, VerilatedVcd* tracep) {
    Vtb_fifo__Syms* __restrict vlSymsp = static_cast<Vtb_fifo__Syms*>(userp);
    Vtb_fifo* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    const int c = vlSymsp->__Vm_baseCode;
    if (false && tracep && c) {}  // Prevent unused
    // Body
    {
        tracep->declBit(c+30,"clk", false,-1);
        tracep->declBit(c+31,"rst_n", false,-1);
        tracep->declBit(c+30,"tb_fifo clk", false,-1);
        tracep->declBit(c+31,"tb_fifo rst_n", false,-1);
        tracep->declBus(c+1,"tb_fifo enq_data0", false,-1, 9,0);
        tracep->declBit(c+2,"tb_fifo enq_valid0", false,-1);
        tracep->declBit(c+22,"tb_fifo enq_ready0", false,-1);
        tracep->declBus(c+18,"tb_fifo deq_data0", false,-1, 9,0);
        tracep->declBit(c+23,"tb_fifo deq_valid0", false,-1);
        tracep->declBit(c+3,"tb_fifo deq_ready0", false,-1);
        tracep->declBit(c+34,"tb_fifo flush0", false,-1);
        tracep->declBit(c+24,"tb_fifo full0", false,-1);
        tracep->declBit(c+25,"tb_fifo empty0", false,-1);
        tracep->declBit(c+35,"tb_fifo enq_data1", false,-1);
        tracep->declBit(c+36,"tb_fifo enq_valid1", false,-1);
        tracep->declBit(c+26,"tb_fifo enq_ready1", false,-1);
        tracep->declBit(c+19,"tb_fifo deq_data1", false,-1);
        tracep->declBit(c+27,"tb_fifo deq_valid1", false,-1);
        tracep->declBit(c+37,"tb_fifo deq_ready1", false,-1);
        tracep->declBit(c+38,"tb_fifo flush1", false,-1);
        tracep->declBit(c+28,"tb_fifo full1", false,-1);
        tracep->declBit(c+29,"tb_fifo empty1", false,-1);
        tracep->declBus(c+39,"tb_fifo fifo_0_i data_size", false,-1, 31,0);
        tracep->declBus(c+40,"tb_fifo fifo_0_i buffer_size", false,-1, 31,0);
        tracep->declBit(c+30,"tb_fifo fifo_0_i clk", false,-1);
        tracep->declBit(c+31,"tb_fifo fifo_0_i rst_n", false,-1);
        tracep->declBus(c+1,"tb_fifo fifo_0_i enq_data", false,-1, 9,0);
        tracep->declBit(c+2,"tb_fifo fifo_0_i enq_valid", false,-1);
        tracep->declBit(c+22,"tb_fifo fifo_0_i enq_ready", false,-1);
        tracep->declBus(c+18,"tb_fifo fifo_0_i deq_data", false,-1, 9,0);
        tracep->declBit(c+23,"tb_fifo fifo_0_i deq_valid", false,-1);
        tracep->declBit(c+3,"tb_fifo fifo_0_i deq_ready", false,-1);
        tracep->declBit(c+34,"tb_fifo fifo_0_i flush", false,-1);
        tracep->declBit(c+24,"tb_fifo fifo_0_i full", false,-1);
        tracep->declBit(c+25,"tb_fifo fifo_0_i empty", false,-1);
        {int i; for (i=0; i<5; i++) {
                tracep->declBus(c+6+i*1,"tb_fifo fifo_0_i genblk2 data", true,(i+0), 9,0);}}
        tracep->declBus(c+20,"tb_fifo fifo_0_i genblk2 wr_ptr", false,-1, 4,0);
        tracep->declBus(c+32,"tb_fifo fifo_0_i genblk2 rd_ptr", false,-1, 4,0);
        tracep->declBus(c+11,"tb_fifo fifo_0_i genblk2 unnamedblk1 i", false,-1, 31,0);
        tracep->declBus(c+4,"tb_fifo fifo_0_i genblk2 unnamedblk2 i", false,-1, 31,0);
        tracep->declBus(c+41,"tb_fifo fifo_1_i data_size", false,-1, 31,0);
        tracep->declBus(c+40,"tb_fifo fifo_1_i buffer_size", false,-1, 31,0);
        tracep->declBit(c+30,"tb_fifo fifo_1_i clk", false,-1);
        tracep->declBit(c+31,"tb_fifo fifo_1_i rst_n", false,-1);
        tracep->declBus(c+35,"tb_fifo fifo_1_i enq_data", false,-1, 0,0);
        tracep->declBit(c+36,"tb_fifo fifo_1_i enq_valid", false,-1);
        tracep->declBit(c+26,"tb_fifo fifo_1_i enq_ready", false,-1);
        tracep->declBus(c+19,"tb_fifo fifo_1_i deq_data", false,-1, 0,0);
        tracep->declBit(c+27,"tb_fifo fifo_1_i deq_valid", false,-1);
        tracep->declBit(c+37,"tb_fifo fifo_1_i deq_ready", false,-1);
        tracep->declBit(c+38,"tb_fifo fifo_1_i flush", false,-1);
        tracep->declBit(c+28,"tb_fifo fifo_1_i full", false,-1);
        tracep->declBit(c+29,"tb_fifo fifo_1_i empty", false,-1);
        {int i; for (i=0; i<5; i++) {
                tracep->declBus(c+12+i*1,"tb_fifo fifo_1_i genblk2 data", true,(i+0), 0,0);}}
        tracep->declBus(c+21,"tb_fifo fifo_1_i genblk2 wr_ptr", false,-1, 4,0);
        tracep->declBus(c+33,"tb_fifo fifo_1_i genblk2 rd_ptr", false,-1, 4,0);
        tracep->declBus(c+17,"tb_fifo fifo_1_i genblk2 unnamedblk1 i", false,-1, 31,0);
        tracep->declBus(c+5,"tb_fifo fifo_1_i genblk2 unnamedblk2 i", false,-1, 31,0);
    }
}

void Vtb_fifo::traceRegister(VerilatedVcd* tracep) {
    // Body
    {
        tracep->addFullCb(&traceFullTop0, __VlSymsp);
        tracep->addChgCb(&traceChgTop0, __VlSymsp);
        tracep->addCleanupCb(&traceCleanup, __VlSymsp);
    }
}

void Vtb_fifo::traceFullTop0(void* userp, VerilatedVcd* tracep) {
    Vtb_fifo__Syms* __restrict vlSymsp = static_cast<Vtb_fifo__Syms*>(userp);
    Vtb_fifo* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    {
        vlTOPp->traceFullSub0(userp, tracep);
    }
}

void Vtb_fifo::traceFullSub0(void* userp, VerilatedVcd* tracep) {
    Vtb_fifo__Syms* __restrict vlSymsp = static_cast<Vtb_fifo__Syms*>(userp);
    Vtb_fifo* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    vluint32_t* const oldp = tracep->oldp(vlSymsp->__Vm_baseCode);
    if (false && oldp) {}  // Prevent unused
    // Body
    {
        tracep->fullSData(oldp+1,(vlTOPp->tb_fifo__DOT__enq_data0),10);
        tracep->fullBit(oldp+2,(vlTOPp->tb_fifo__DOT__enq_valid0));
        tracep->fullBit(oldp+3,(vlTOPp->tb_fifo__DOT__deq_ready0));
        tracep->fullIData(oldp+4,(vlTOPp->tb_fifo__DOT__fifo_0_i__DOT__genblk2__DOT__unnamedblk2__DOT__i),32);
        tracep->fullIData(oldp+5,(vlTOPp->tb_fifo__DOT__fifo_1_i__DOT__genblk2__DOT__unnamedblk2__DOT__i),32);
        tracep->fullSData(oldp+6,(vlTOPp->tb_fifo__DOT__fifo_0_i__DOT__genblk2__DOT__data[0]),10);
        tracep->fullSData(oldp+7,(vlTOPp->tb_fifo__DOT__fifo_0_i__DOT__genblk2__DOT__data[1]),10);
        tracep->fullSData(oldp+8,(vlTOPp->tb_fifo__DOT__fifo_0_i__DOT__genblk2__DOT__data[2]),10);
        tracep->fullSData(oldp+9,(vlTOPp->tb_fifo__DOT__fifo_0_i__DOT__genblk2__DOT__data[3]),10);
        tracep->fullSData(oldp+10,(vlTOPp->tb_fifo__DOT__fifo_0_i__DOT__genblk2__DOT__data[4]),10);
        tracep->fullIData(oldp+11,(vlTOPp->tb_fifo__DOT__fifo_0_i__DOT__genblk2__DOT__unnamedblk1__DOT__i),32);
        tracep->fullBit(oldp+12,(vlTOPp->tb_fifo__DOT__fifo_1_i__DOT__genblk2__DOT__data[0]));
        tracep->fullBit(oldp+13,(vlTOPp->tb_fifo__DOT__fifo_1_i__DOT__genblk2__DOT__data[1]));
        tracep->fullBit(oldp+14,(vlTOPp->tb_fifo__DOT__fifo_1_i__DOT__genblk2__DOT__data[2]));
        tracep->fullBit(oldp+15,(vlTOPp->tb_fifo__DOT__fifo_1_i__DOT__genblk2__DOT__data[3]));
        tracep->fullBit(oldp+16,(vlTOPp->tb_fifo__DOT__fifo_1_i__DOT__genblk2__DOT__data[4]));
        tracep->fullIData(oldp+17,(vlTOPp->tb_fifo__DOT__fifo_1_i__DOT__genblk2__DOT__unnamedblk1__DOT__i),32);
        tracep->fullSData(oldp+18,(vlTOPp->tb_fifo__DOT__deq_data0),10);
        tracep->fullBit(oldp+19,(vlTOPp->tb_fifo__DOT__deq_data1));
        tracep->fullCData(oldp+20,(vlTOPp->tb_fifo__DOT__fifo_0_i__DOT__genblk2__DOT__wr_ptr),5);
        tracep->fullCData(oldp+21,(vlTOPp->tb_fifo__DOT__fifo_1_i__DOT__genblk2__DOT__wr_ptr),5);
        tracep->fullBit(oldp+22,(vlTOPp->tb_fifo__DOT__enq_ready0));
        tracep->fullBit(oldp+23,(vlTOPp->tb_fifo__DOT__deq_valid0));
        tracep->fullBit(oldp+24,(vlTOPp->tb_fifo__DOT__full0));
        tracep->fullBit(oldp+25,(vlTOPp->tb_fifo__DOT__empty0));
        tracep->fullBit(oldp+26,(vlTOPp->tb_fifo__DOT__enq_ready1));
        tracep->fullBit(oldp+27,(vlTOPp->tb_fifo__DOT__deq_valid1));
        tracep->fullBit(oldp+28,(vlTOPp->tb_fifo__DOT__full1));
        tracep->fullBit(oldp+29,(vlTOPp->tb_fifo__DOT__empty1));
        tracep->fullBit(oldp+30,(vlTOPp->clk));
        tracep->fullBit(oldp+31,(vlTOPp->rst_n));
        tracep->fullCData(oldp+32,(vlTOPp->tb_fifo__DOT__fifo_0_i__DOT__genblk2__DOT__rd_ptr),5);
        tracep->fullCData(oldp+33,(vlTOPp->tb_fifo__DOT__fifo_1_i__DOT__genblk2__DOT__rd_ptr),5);
        tracep->fullBit(oldp+34,(vlTOPp->tb_fifo__DOT__flush0));
        tracep->fullBit(oldp+35,(vlTOPp->tb_fifo__DOT__enq_data1));
        tracep->fullBit(oldp+36,(vlTOPp->tb_fifo__DOT__enq_valid1));
        tracep->fullBit(oldp+37,(vlTOPp->tb_fifo__DOT__deq_ready1));
        tracep->fullBit(oldp+38,(vlTOPp->tb_fifo__DOT__flush1));
        tracep->fullIData(oldp+39,(0xaU),32);
        tracep->fullIData(oldp+40,(5U),32);
        tracep->fullIData(oldp+41,(1U),32);
    }
}
