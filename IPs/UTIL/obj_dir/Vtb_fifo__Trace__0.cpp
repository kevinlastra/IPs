// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vtb_fifo__Syms.h"


void Vtb_fifo___024root__trace_chg_0_sub_0(Vtb_fifo___024root* vlSelf, VerilatedVcd::Buffer* bufp);

void Vtb_fifo___024root__trace_chg_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_fifo___024root__trace_chg_0\n"); );
    // Init
    Vtb_fifo___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vtb_fifo___024root*>(voidSelf);
    Vtb_fifo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (VL_UNLIKELY(!vlSymsp->__Vm_activity)) return;
    // Body
    Vtb_fifo___024root__trace_chg_0_sub_0((&vlSymsp->TOP), bufp);
}

void Vtb_fifo___024root__trace_chg_0_sub_0(Vtb_fifo___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    (void)vlSelf;  // Prevent unused variable warning
    Vtb_fifo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_fifo___024root__trace_chg_0_sub_0\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode + 1);
    // Body
    if (VL_UNLIKELY(vlSelfRef.__Vm_traceActivity[1U])) {
        bufp->chgSData(oldp+0,(vlSelfRef.tb_fifo__DOT__value),10);
        bufp->chgCData(oldp+1,(vlSelfRef.tb_fifo__DOT__f0state),5);
        bufp->chgCData(oldp+2,(vlSelfRef.tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__rd_ptr),5);
    }
    if (VL_UNLIKELY(vlSelfRef.__Vm_traceActivity[2U])) {
        bufp->chgSData(oldp+3,(vlSelfRef.tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data[0]),10);
        bufp->chgSData(oldp+4,(vlSelfRef.tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data[1]),10);
        bufp->chgSData(oldp+5,(vlSelfRef.tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data[2]),10);
        bufp->chgSData(oldp+6,(vlSelfRef.tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data[3]),10);
        bufp->chgSData(oldp+7,(vlSelfRef.tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data[4]),10);
        bufp->chgIData(oldp+8,(vlSelfRef.tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__unnamedblk1__DOT__i),32);
    }
    if (VL_UNLIKELY(vlSelfRef.__Vm_traceActivity[3U])) {
        bufp->chgSData(oldp+9,(vlSelfRef.tb_fifo__DOT__enq_data0),10);
        bufp->chgBit(oldp+10,(vlSelfRef.tb_fifo__DOT__enq_valid0));
        bufp->chgBit(oldp+11,((1U & (~ (IData)(vlSelfRef.tb_fifo__DOT__full0)))));
        bufp->chgSData(oldp+12,(vlSelfRef.tb_fifo__DOT__deq_data0),10);
        bufp->chgBit(oldp+13,((1U & (~ (IData)(vlSelfRef.tb_fifo__DOT__empty0)))));
        bufp->chgBit(oldp+14,(vlSelfRef.tb_fifo__DOT__deq_ready0));
        bufp->chgBit(oldp+15,(vlSelfRef.tb_fifo__DOT__full0));
        bufp->chgBit(oldp+16,(vlSelfRef.tb_fifo__DOT__empty0));
        bufp->chgSData(oldp+17,(vlSelfRef.tb_fifo__DOT__value_n),10);
        bufp->chgCData(oldp+18,(vlSelfRef.tb_fifo__DOT__f0state_n),5);
        bufp->chgCData(oldp+19,(vlSelfRef.tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__wr_ptr),5);
    }
    bufp->chgBit(oldp+20,(vlSelfRef.clk));
    bufp->chgBit(oldp+21,(vlSelfRef.rst_n));
}

void Vtb_fifo___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_fifo___024root__trace_cleanup\n"); );
    // Init
    Vtb_fifo___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vtb_fifo___024root*>(voidSelf);
    Vtb_fifo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    // Body
    vlSymsp->__Vm_activity = false;
    vlSymsp->TOP.__Vm_traceActivity[0U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[1U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[2U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[3U] = 0U;
}
