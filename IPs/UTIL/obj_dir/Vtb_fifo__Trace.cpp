// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vtb_fifo__Syms.h"


void Vtb_fifo::traceChgTop0(void* userp, VerilatedVcd* tracep) {
    Vtb_fifo__Syms* __restrict vlSymsp = static_cast<Vtb_fifo__Syms*>(userp);
    Vtb_fifo* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Variables
    if (VL_UNLIKELY(!vlSymsp->__Vm_activity)) return;
    // Body
    {
        vlTOPp->traceChgSub0(userp, tracep);
    }
}

void Vtb_fifo::traceChgSub0(void* userp, VerilatedVcd* tracep) {
    Vtb_fifo__Syms* __restrict vlSymsp = static_cast<Vtb_fifo__Syms*>(userp);
    Vtb_fifo* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    vluint32_t* const oldp = tracep->oldp(vlSymsp->__Vm_baseCode + 1);
    if (false && oldp) {}  // Prevent unused
    // Body
    {
        if (VL_UNLIKELY(vlTOPp->__Vm_traceActivity[0U])) {
            tracep->chgSData(oldp+0,(vlTOPp->tb_fifo__DOT__enq_data0),10);
            tracep->chgBit(oldp+1,(vlTOPp->tb_fifo__DOT__enq_valid0));
            tracep->chgBit(oldp+2,(vlTOPp->tb_fifo__DOT__deq_ready0));
            tracep->chgIData(oldp+3,(vlTOPp->tb_fifo__DOT__fifo_0_i__DOT__genblk2__DOT__unnamedblk2__DOT__i),32);
            tracep->chgIData(oldp+4,(vlTOPp->tb_fifo__DOT__fifo_1_i__DOT__genblk2__DOT__unnamedblk2__DOT__i),32);
        }
        if (VL_UNLIKELY(vlTOPp->__Vm_traceActivity[1U])) {
            tracep->chgSData(oldp+5,(vlTOPp->tb_fifo__DOT__fifo_0_i__DOT__genblk2__DOT__data[0]),10);
            tracep->chgSData(oldp+6,(vlTOPp->tb_fifo__DOT__fifo_0_i__DOT__genblk2__DOT__data[1]),10);
            tracep->chgSData(oldp+7,(vlTOPp->tb_fifo__DOT__fifo_0_i__DOT__genblk2__DOT__data[2]),10);
            tracep->chgSData(oldp+8,(vlTOPp->tb_fifo__DOT__fifo_0_i__DOT__genblk2__DOT__data[3]),10);
            tracep->chgSData(oldp+9,(vlTOPp->tb_fifo__DOT__fifo_0_i__DOT__genblk2__DOT__data[4]),10);
            tracep->chgIData(oldp+10,(vlTOPp->tb_fifo__DOT__fifo_0_i__DOT__genblk2__DOT__unnamedblk1__DOT__i),32);
            tracep->chgBit(oldp+11,(vlTOPp->tb_fifo__DOT__fifo_1_i__DOT__genblk2__DOT__data[0]));
            tracep->chgBit(oldp+12,(vlTOPp->tb_fifo__DOT__fifo_1_i__DOT__genblk2__DOT__data[1]));
            tracep->chgBit(oldp+13,(vlTOPp->tb_fifo__DOT__fifo_1_i__DOT__genblk2__DOT__data[2]));
            tracep->chgBit(oldp+14,(vlTOPp->tb_fifo__DOT__fifo_1_i__DOT__genblk2__DOT__data[3]));
            tracep->chgBit(oldp+15,(vlTOPp->tb_fifo__DOT__fifo_1_i__DOT__genblk2__DOT__data[4]));
            tracep->chgIData(oldp+16,(vlTOPp->tb_fifo__DOT__fifo_1_i__DOT__genblk2__DOT__unnamedblk1__DOT__i),32);
        }
        if (VL_UNLIKELY(vlTOPp->__Vm_traceActivity[2U])) {
            tracep->chgSData(oldp+17,(vlTOPp->tb_fifo__DOT__deq_data0),10);
            tracep->chgBit(oldp+18,(vlTOPp->tb_fifo__DOT__deq_data1));
            tracep->chgCData(oldp+19,(vlTOPp->tb_fifo__DOT__fifo_0_i__DOT__genblk2__DOT__wr_ptr),5);
            tracep->chgCData(oldp+20,(vlTOPp->tb_fifo__DOT__fifo_1_i__DOT__genblk2__DOT__wr_ptr),5);
        }
        if (VL_UNLIKELY(vlTOPp->__Vm_traceActivity[3U])) {
            tracep->chgBit(oldp+21,(vlTOPp->tb_fifo__DOT__enq_ready0));
            tracep->chgBit(oldp+22,(vlTOPp->tb_fifo__DOT__deq_valid0));
            tracep->chgBit(oldp+23,(vlTOPp->tb_fifo__DOT__full0));
            tracep->chgBit(oldp+24,(vlTOPp->tb_fifo__DOT__empty0));
            tracep->chgBit(oldp+25,(vlTOPp->tb_fifo__DOT__enq_ready1));
            tracep->chgBit(oldp+26,(vlTOPp->tb_fifo__DOT__deq_valid1));
            tracep->chgBit(oldp+27,(vlTOPp->tb_fifo__DOT__full1));
            tracep->chgBit(oldp+28,(vlTOPp->tb_fifo__DOT__empty1));
        }
        tracep->chgBit(oldp+29,(vlTOPp->clk));
        tracep->chgBit(oldp+30,(vlTOPp->rst_n));
        tracep->chgCData(oldp+31,(vlTOPp->tb_fifo__DOT__fifo_0_i__DOT__genblk2__DOT__rd_ptr),5);
        tracep->chgCData(oldp+32,(vlTOPp->tb_fifo__DOT__fifo_1_i__DOT__genblk2__DOT__rd_ptr),5);
    }
}

void Vtb_fifo::traceCleanup(void* userp, VerilatedVcd* /*unused*/) {
    Vtb_fifo__Syms* __restrict vlSymsp = static_cast<Vtb_fifo__Syms*>(userp);
    Vtb_fifo* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    {
        vlSymsp->__Vm_activity = false;
        vlTOPp->__Vm_traceActivity[0U] = 0U;
        vlTOPp->__Vm_traceActivity[1U] = 0U;
        vlTOPp->__Vm_traceActivity[2U] = 0U;
        vlTOPp->__Vm_traceActivity[3U] = 0U;
    }
}
