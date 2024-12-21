// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtb_fifo.h for the primary calling header

#include "Vtb_fifo.h"
#include "Vtb_fifo__Syms.h"

//==========

VL_CTOR_IMP(Vtb_fifo) {
    Vtb_fifo__Syms* __restrict vlSymsp = __VlSymsp = new Vtb_fifo__Syms(this, name());
    Vtb_fifo* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Reset internal values
    
    // Reset structure values
    _ctor_var_reset();
}

void Vtb_fifo::__Vconfigure(Vtb_fifo__Syms* vlSymsp, bool first) {
    if (false && first) {}  // Prevent unused
    this->__VlSymsp = vlSymsp;
    if (false && this->__VlSymsp) {}  // Prevent unused
    Verilated::timeunit(-12);
    Verilated::timeprecision(-12);
}

Vtb_fifo::~Vtb_fifo() {
    VL_DO_CLEAR(delete __VlSymsp, __VlSymsp = NULL);
}

void Vtb_fifo::_settle__TOP__1(Vtb_fifo__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_fifo::_settle__TOP__1\n"); );
    Vtb_fifo* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    if (vlTOPp->tb_fifo__DOT__deq_ready1) {
        vlTOPp->tb_fifo__DOT__fifo_1_i__DOT__genblk2__DOT__unnamedblk2__DOT__i = 5U;
    }
    if (vlTOPp->tb_fifo__DOT__deq_ready1) {
        if ((1U & (IData)(vlTOPp->tb_fifo__DOT__fifo_1_i__DOT__genblk2__DOT__rd_ptr))) {
            vlTOPp->tb_fifo__DOT__deq_data1 = vlTOPp->tb_fifo__DOT__fifo_1_i__DOT__genblk2__DOT__data
                [0U];
        }
        if ((2U & (IData)(vlTOPp->tb_fifo__DOT__fifo_1_i__DOT__genblk2__DOT__rd_ptr))) {
            vlTOPp->tb_fifo__DOT__deq_data1 = vlTOPp->tb_fifo__DOT__fifo_1_i__DOT__genblk2__DOT__data
                [1U];
        }
        if ((4U & (IData)(vlTOPp->tb_fifo__DOT__fifo_1_i__DOT__genblk2__DOT__rd_ptr))) {
            vlTOPp->tb_fifo__DOT__deq_data1 = vlTOPp->tb_fifo__DOT__fifo_1_i__DOT__genblk2__DOT__data
                [2U];
        }
        if ((8U & (IData)(vlTOPp->tb_fifo__DOT__fifo_1_i__DOT__genblk2__DOT__rd_ptr))) {
            vlTOPp->tb_fifo__DOT__deq_data1 = vlTOPp->tb_fifo__DOT__fifo_1_i__DOT__genblk2__DOT__data
                [3U];
        }
        if ((0x10U & (IData)(vlTOPp->tb_fifo__DOT__fifo_1_i__DOT__genblk2__DOT__rd_ptr))) {
            vlTOPp->tb_fifo__DOT__deq_data1 = vlTOPp->tb_fifo__DOT__fifo_1_i__DOT__genblk2__DOT__data
                [4U];
        }
    }
    vlTOPp->tb_fifo__DOT__enq_ready0 = (1U & (~ (IData)(vlTOPp->tb_fifo__DOT__full0)));
    vlTOPp->tb_fifo__DOT__full0 = ((0U == ((IData)(vlTOPp->tb_fifo__DOT__fifo_0_i__DOT__genblk2__DOT__wr_ptr) 
                                           << 1U)) ? 
                                   ((1U == (IData)(vlTOPp->tb_fifo__DOT__fifo_0_i__DOT__genblk2__DOT__rd_ptr)) 
                                    & (~ (IData)(vlTOPp->tb_fifo__DOT__flush0)))
                                    : (((0x1fU & ((IData)(vlTOPp->tb_fifo__DOT__fifo_0_i__DOT__genblk2__DOT__wr_ptr) 
                                                  << 1U)) 
                                        == (IData)(vlTOPp->tb_fifo__DOT__fifo_0_i__DOT__genblk2__DOT__rd_ptr)) 
                                       & (~ (IData)(vlTOPp->tb_fifo__DOT__flush0))));
    vlTOPp->tb_fifo__DOT__deq_valid0 = (1U & (~ (IData)(vlTOPp->tb_fifo__DOT__empty0)));
    vlTOPp->tb_fifo__DOT__empty0 = (((IData)(vlTOPp->tb_fifo__DOT__fifo_0_i__DOT__genblk2__DOT__wr_ptr) 
                                     == (IData)(vlTOPp->tb_fifo__DOT__fifo_0_i__DOT__genblk2__DOT__rd_ptr)) 
                                    & (IData)(vlTOPp->tb_fifo__DOT__flush0));
    vlTOPp->tb_fifo__DOT__enq_ready1 = (1U & (~ (IData)(vlTOPp->tb_fifo__DOT__full1)));
    vlTOPp->tb_fifo__DOT__full1 = ((0U == ((IData)(vlTOPp->tb_fifo__DOT__fifo_1_i__DOT__genblk2__DOT__wr_ptr) 
                                           << 1U)) ? 
                                   ((1U == (IData)(vlTOPp->tb_fifo__DOT__fifo_1_i__DOT__genblk2__DOT__rd_ptr)) 
                                    & (~ (IData)(vlTOPp->tb_fifo__DOT__flush1)))
                                    : (((0x1fU & ((IData)(vlTOPp->tb_fifo__DOT__fifo_1_i__DOT__genblk2__DOT__wr_ptr) 
                                                  << 1U)) 
                                        == (IData)(vlTOPp->tb_fifo__DOT__fifo_1_i__DOT__genblk2__DOT__rd_ptr)) 
                                       & (~ (IData)(vlTOPp->tb_fifo__DOT__flush1))));
    vlTOPp->tb_fifo__DOT__deq_valid1 = (1U & (~ (IData)(vlTOPp->tb_fifo__DOT__empty1)));
    vlTOPp->tb_fifo__DOT__empty1 = (((IData)(vlTOPp->tb_fifo__DOT__fifo_1_i__DOT__genblk2__DOT__wr_ptr) 
                                     == (IData)(vlTOPp->tb_fifo__DOT__fifo_1_i__DOT__genblk2__DOT__rd_ptr)) 
                                    & (IData)(vlTOPp->tb_fifo__DOT__flush1));
}

void Vtb_fifo::_initial__TOP__4(Vtb_fifo__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_fifo::_initial__TOP__4\n"); );
    Vtb_fifo* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->tb_fifo__DOT__deq_ready0 = 1U;
    vlTOPp->tb_fifo__DOT__enq_data0 = 2U;
    vlTOPp->tb_fifo__DOT__enq_valid0 = 1U;
    vlTOPp->tb_fifo__DOT__fifo_0_i__DOT__genblk2__DOT__unnamedblk2__DOT__i = 5U;
}

void Vtb_fifo::_settle__TOP__6(Vtb_fifo__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_fifo::_settle__TOP__6\n"); );
    Vtb_fifo* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    if (vlTOPp->tb_fifo__DOT__deq_ready0) {
        vlTOPp->tb_fifo__DOT__fifo_0_i__DOT__genblk2__DOT__unnamedblk2__DOT__i = 5U;
    }
    if (vlTOPp->tb_fifo__DOT__deq_ready0) {
        if ((1U & (IData)(vlTOPp->tb_fifo__DOT__fifo_0_i__DOT__genblk2__DOT__rd_ptr))) {
            vlTOPp->tb_fifo__DOT__deq_data0 = vlTOPp->tb_fifo__DOT__fifo_0_i__DOT__genblk2__DOT__data
                [0U];
        }
        if ((2U & (IData)(vlTOPp->tb_fifo__DOT__fifo_0_i__DOT__genblk2__DOT__rd_ptr))) {
            vlTOPp->tb_fifo__DOT__deq_data0 = vlTOPp->tb_fifo__DOT__fifo_0_i__DOT__genblk2__DOT__data
                [1U];
        }
        if ((4U & (IData)(vlTOPp->tb_fifo__DOT__fifo_0_i__DOT__genblk2__DOT__rd_ptr))) {
            vlTOPp->tb_fifo__DOT__deq_data0 = vlTOPp->tb_fifo__DOT__fifo_0_i__DOT__genblk2__DOT__data
                [2U];
        }
        if ((8U & (IData)(vlTOPp->tb_fifo__DOT__fifo_0_i__DOT__genblk2__DOT__rd_ptr))) {
            vlTOPp->tb_fifo__DOT__deq_data0 = vlTOPp->tb_fifo__DOT__fifo_0_i__DOT__genblk2__DOT__data
                [3U];
        }
        if ((0x10U & (IData)(vlTOPp->tb_fifo__DOT__fifo_0_i__DOT__genblk2__DOT__rd_ptr))) {
            vlTOPp->tb_fifo__DOT__deq_data0 = vlTOPp->tb_fifo__DOT__fifo_0_i__DOT__genblk2__DOT__data
                [4U];
        }
    }
}

void Vtb_fifo::_eval_initial(Vtb_fifo__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_fifo::_eval_initial\n"); );
    Vtb_fifo* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->__Vclklast__TOP__clk = vlTOPp->clk;
    vlTOPp->__Vclklast__TOP__rst_n = vlTOPp->rst_n;
    vlTOPp->_initial__TOP__4(vlSymsp);
    vlTOPp->__Vm_traceActivity[3U] = 1U;
    vlTOPp->__Vm_traceActivity[2U] = 1U;
    vlTOPp->__Vm_traceActivity[1U] = 1U;
    vlTOPp->__Vm_traceActivity[0U] = 1U;
}

void Vtb_fifo::final() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_fifo::final\n"); );
    // Variables
    Vtb_fifo__Syms* __restrict vlSymsp = this->__VlSymsp;
    Vtb_fifo* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
}

void Vtb_fifo::_eval_settle(Vtb_fifo__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_fifo::_eval_settle\n"); );
    Vtb_fifo* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->_settle__TOP__1(vlSymsp);
    vlTOPp->__Vm_traceActivity[3U] = 1U;
    vlTOPp->__Vm_traceActivity[2U] = 1U;
    vlTOPp->__Vm_traceActivity[1U] = 1U;
    vlTOPp->__Vm_traceActivity[0U] = 1U;
    vlTOPp->_settle__TOP__6(vlSymsp);
}

void Vtb_fifo::_ctor_var_reset() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_fifo::_ctor_var_reset\n"); );
    // Body
    clk = VL_RAND_RESET_I(1);
    rst_n = VL_RAND_RESET_I(1);
    tb_fifo__DOT__enq_data0 = VL_RAND_RESET_I(10);
    tb_fifo__DOT__enq_valid0 = VL_RAND_RESET_I(1);
    tb_fifo__DOT__enq_ready0 = VL_RAND_RESET_I(1);
    tb_fifo__DOT__deq_data0 = VL_RAND_RESET_I(10);
    tb_fifo__DOT__deq_valid0 = VL_RAND_RESET_I(1);
    tb_fifo__DOT__deq_ready0 = VL_RAND_RESET_I(1);
    tb_fifo__DOT__flush0 = VL_RAND_RESET_I(1);
    tb_fifo__DOT__full0 = VL_RAND_RESET_I(1);
    tb_fifo__DOT__empty0 = VL_RAND_RESET_I(1);
    tb_fifo__DOT__enq_data1 = VL_RAND_RESET_I(1);
    tb_fifo__DOT__enq_valid1 = VL_RAND_RESET_I(1);
    tb_fifo__DOT__enq_ready1 = VL_RAND_RESET_I(1);
    tb_fifo__DOT__deq_data1 = VL_RAND_RESET_I(1);
    tb_fifo__DOT__deq_valid1 = VL_RAND_RESET_I(1);
    tb_fifo__DOT__deq_ready1 = VL_RAND_RESET_I(1);
    tb_fifo__DOT__flush1 = VL_RAND_RESET_I(1);
    tb_fifo__DOT__full1 = VL_RAND_RESET_I(1);
    tb_fifo__DOT__empty1 = VL_RAND_RESET_I(1);
    { int __Vi0=0; for (; __Vi0<5; ++__Vi0) {
            tb_fifo__DOT__fifo_0_i__DOT__genblk2__DOT__data[__Vi0] = VL_RAND_RESET_I(10);
    }}
    tb_fifo__DOT__fifo_0_i__DOT__genblk2__DOT__wr_ptr = VL_RAND_RESET_I(5);
    tb_fifo__DOT__fifo_0_i__DOT__genblk2__DOT__rd_ptr = VL_RAND_RESET_I(5);
    tb_fifo__DOT__fifo_0_i__DOT__genblk2__DOT__unnamedblk1__DOT__i = 0;
    tb_fifo__DOT__fifo_0_i__DOT__genblk2__DOT__unnamedblk2__DOT__i = 0;
    tb_fifo__DOT__fifo_0_i__DOT____Vlvbound1 = VL_RAND_RESET_I(10);
    { int __Vi0=0; for (; __Vi0<5; ++__Vi0) {
            tb_fifo__DOT__fifo_1_i__DOT__genblk2__DOT__data[__Vi0] = VL_RAND_RESET_I(1);
    }}
    tb_fifo__DOT__fifo_1_i__DOT__genblk2__DOT__wr_ptr = VL_RAND_RESET_I(5);
    tb_fifo__DOT__fifo_1_i__DOT__genblk2__DOT__rd_ptr = VL_RAND_RESET_I(5);
    tb_fifo__DOT__fifo_1_i__DOT__genblk2__DOT__unnamedblk1__DOT__i = 0;
    tb_fifo__DOT__fifo_1_i__DOT__genblk2__DOT__unnamedblk2__DOT__i = 0;
    tb_fifo__DOT__fifo_1_i__DOT____Vlvbound1 = VL_RAND_RESET_I(1);
    __Vdly__tb_fifo__DOT__fifo_0_i__DOT__genblk2__DOT__wr_ptr = VL_RAND_RESET_I(5);
    __Vdly__tb_fifo__DOT__fifo_1_i__DOT__genblk2__DOT__wr_ptr = VL_RAND_RESET_I(5);
    __Vchglast__TOP__tb_fifo__DOT__full0 = VL_RAND_RESET_I(1);
    __Vchglast__TOP__tb_fifo__DOT__empty0 = VL_RAND_RESET_I(1);
    __Vchglast__TOP__tb_fifo__DOT__full1 = VL_RAND_RESET_I(1);
    __Vchglast__TOP__tb_fifo__DOT__empty1 = VL_RAND_RESET_I(1);
    { int __Vi0=0; for (; __Vi0<4; ++__Vi0) {
            __Vm_traceActivity[__Vi0] = VL_RAND_RESET_I(1);
    }}
}
