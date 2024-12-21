// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtb_fifo.h for the primary calling header

#include "Vtb_fifo__pch.h"
#include "Vtb_fifo___024root.h"

void Vtb_fifo___024root___eval_act(Vtb_fifo___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vtb_fifo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_fifo___024root___eval_act\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

void Vtb_fifo___024root___nba_sequent__TOP__0(Vtb_fifo___024root* vlSelf);
void Vtb_fifo___024root___nba_sequent__TOP__1(Vtb_fifo___024root* vlSelf);
void Vtb_fifo___024root___nba_sequent__TOP__2(Vtb_fifo___024root* vlSelf);
void Vtb_fifo___024root___nba_comb__TOP__0(Vtb_fifo___024root* vlSelf);

void Vtb_fifo___024root___eval_nba(Vtb_fifo___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vtb_fifo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_fifo___024root___eval_nba\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((3ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        Vtb_fifo___024root___nba_sequent__TOP__0(vlSelf);
        vlSelfRef.__Vm_traceActivity[1U] = 1U;
    }
    if ((1ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        Vtb_fifo___024root___nba_sequent__TOP__1(vlSelf);
        vlSelfRef.__Vm_traceActivity[2U] = 1U;
    }
    if ((3ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        Vtb_fifo___024root___nba_sequent__TOP__2(vlSelf);
        vlSelfRef.__Vm_traceActivity[3U] = 1U;
        Vtb_fifo___024root___nba_comb__TOP__0(vlSelf);
    }
}

VL_INLINE_OPT void Vtb_fifo___024root___nba_sequent__TOP__0(Vtb_fifo___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vtb_fifo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_fifo___024root___nba_sequent__TOP__0\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    CData/*4:0*/ __Vdly__tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__rd_ptr;
    __Vdly__tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__rd_ptr = 0;
    // Body
    vlSelfRef.__Vdly__tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__wr_ptr 
        = vlSelfRef.tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__wr_ptr;
    __Vdly__tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__rd_ptr 
        = vlSelfRef.tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__rd_ptr;
    if ((1U & (~ (IData)(vlSelfRef.rst_n)))) {
        vlSelfRef.__Vdly__tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__wr_ptr = 1U;
        __Vdly__tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__rd_ptr = 1U;
    }
    if (((IData)(vlSelfRef.tb_fifo__DOT__enq_valid0) 
         & (~ (IData)(vlSelfRef.tb_fifo__DOT__full0)))) {
        vlSelfRef.__Vdly__tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__wr_ptr 
            = ((0U == (0x1fU & VL_SHIFTL_III(5,5,32, (IData)(vlSelfRef.tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__wr_ptr), 1U)))
                ? 1U : (0x1fU & VL_SHIFTL_III(5,5,32, (IData)(vlSelfRef.tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__wr_ptr), 1U)));
    }
    if (((IData)(vlSelfRef.tb_fifo__DOT__deq_ready0) 
         & (~ (IData)(vlSelfRef.tb_fifo__DOT__empty0)))) {
        __Vdly__tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__rd_ptr 
            = ((0U == (0x1fU & VL_SHIFTL_III(5,5,32, (IData)(vlSelfRef.tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__rd_ptr), 1U)))
                ? 1U : (0x1fU & VL_SHIFTL_III(5,5,32, (IData)(vlSelfRef.tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__rd_ptr), 1U)));
    }
    if (vlSelfRef.rst_n) {
        vlSelfRef.tb_fifo__DOT__f0state = vlSelfRef.tb_fifo__DOT__f0state_n;
        vlSelfRef.tb_fifo__DOT__value = vlSelfRef.tb_fifo__DOT__value_n;
    } else {
        vlSelfRef.tb_fifo__DOT__f0state = 0U;
        vlSelfRef.tb_fifo__DOT__value = 0U;
    }
    vlSelfRef.tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__rd_ptr 
        = __Vdly__tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__rd_ptr;
}

VL_INLINE_OPT void Vtb_fifo___024root___nba_sequent__TOP__1(Vtb_fifo___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vtb_fifo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_fifo___024root___nba_sequent__TOP__1\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    SData/*9:0*/ __VdlyVal__tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data__v0;
    __VdlyVal__tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data__v0 = 0;
    CData/*0:0*/ __VdlySet__tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data__v0;
    __VdlySet__tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data__v0 = 0;
    SData/*9:0*/ __VdlyVal__tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data__v1;
    __VdlyVal__tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data__v1 = 0;
    CData/*0:0*/ __VdlySet__tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data__v1;
    __VdlySet__tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data__v1 = 0;
    SData/*9:0*/ __VdlyVal__tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data__v2;
    __VdlyVal__tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data__v2 = 0;
    CData/*0:0*/ __VdlySet__tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data__v2;
    __VdlySet__tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data__v2 = 0;
    SData/*9:0*/ __VdlyVal__tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data__v3;
    __VdlyVal__tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data__v3 = 0;
    CData/*0:0*/ __VdlySet__tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data__v3;
    __VdlySet__tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data__v3 = 0;
    SData/*9:0*/ __VdlyVal__tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data__v4;
    __VdlyVal__tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data__v4 = 0;
    CData/*0:0*/ __VdlySet__tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data__v4;
    __VdlySet__tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data__v4 = 0;
    // Body
    __VdlySet__tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data__v0 = 0U;
    __VdlySet__tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data__v1 = 0U;
    __VdlySet__tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data__v2 = 0U;
    __VdlySet__tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data__v3 = 0U;
    __VdlySet__tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data__v4 = 0U;
    if (((IData)(vlSelfRef.tb_fifo__DOT__enq_valid0) 
         & (~ (IData)(vlSelfRef.tb_fifo__DOT__full0)))) {
        vlSelfRef.tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__unnamedblk1__DOT__i = 5U;
        if ((1U & (IData)(vlSelfRef.tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__wr_ptr))) {
            vlSelfRef.tb_fifo__DOT__fifo_0_i__DOT____Vlvbound_hb0832a7a__0 
                = vlSelfRef.tb_fifo__DOT__enq_data0;
            __VdlyVal__tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data__v0 
                = vlSelfRef.tb_fifo__DOT__fifo_0_i__DOT____Vlvbound_hb0832a7a__0;
            __VdlySet__tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data__v0 = 1U;
        }
        if ((2U & (IData)(vlSelfRef.tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__wr_ptr))) {
            vlSelfRef.tb_fifo__DOT__fifo_0_i__DOT____Vlvbound_hb0832a7a__0 
                = vlSelfRef.tb_fifo__DOT__enq_data0;
            __VdlyVal__tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data__v1 
                = vlSelfRef.tb_fifo__DOT__fifo_0_i__DOT____Vlvbound_hb0832a7a__0;
            __VdlySet__tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data__v1 = 1U;
        }
        if ((4U & (IData)(vlSelfRef.tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__wr_ptr))) {
            vlSelfRef.tb_fifo__DOT__fifo_0_i__DOT____Vlvbound_hb0832a7a__0 
                = vlSelfRef.tb_fifo__DOT__enq_data0;
            __VdlyVal__tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data__v2 
                = vlSelfRef.tb_fifo__DOT__fifo_0_i__DOT____Vlvbound_hb0832a7a__0;
            __VdlySet__tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data__v2 = 1U;
        }
        if ((8U & (IData)(vlSelfRef.tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__wr_ptr))) {
            vlSelfRef.tb_fifo__DOT__fifo_0_i__DOT____Vlvbound_hb0832a7a__0 
                = vlSelfRef.tb_fifo__DOT__enq_data0;
            __VdlyVal__tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data__v3 
                = vlSelfRef.tb_fifo__DOT__fifo_0_i__DOT____Vlvbound_hb0832a7a__0;
            __VdlySet__tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data__v3 = 1U;
        }
        if ((0x10U & (IData)(vlSelfRef.tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__wr_ptr))) {
            vlSelfRef.tb_fifo__DOT__fifo_0_i__DOT____Vlvbound_hb0832a7a__0 
                = vlSelfRef.tb_fifo__DOT__enq_data0;
            __VdlyVal__tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data__v4 
                = vlSelfRef.tb_fifo__DOT__fifo_0_i__DOT____Vlvbound_hb0832a7a__0;
            __VdlySet__tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data__v4 = 1U;
        }
    }
    if (__VdlySet__tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data__v0) {
        vlSelfRef.tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data[0U] 
            = __VdlyVal__tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data__v0;
    }
    if (__VdlySet__tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data__v1) {
        vlSelfRef.tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data[1U] 
            = __VdlyVal__tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data__v1;
    }
    if (__VdlySet__tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data__v2) {
        vlSelfRef.tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data[2U] 
            = __VdlyVal__tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data__v2;
    }
    if (__VdlySet__tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data__v3) {
        vlSelfRef.tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data[3U] 
            = __VdlyVal__tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data__v3;
    }
    if (__VdlySet__tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data__v4) {
        vlSelfRef.tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data[4U] 
            = __VdlyVal__tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data__v4;
    }
}

VL_INLINE_OPT void Vtb_fifo___024root___nba_sequent__TOP__2(Vtb_fifo___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vtb_fifo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_fifo___024root___nba_sequent__TOP__2\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__wr_ptr 
        = vlSelfRef.__Vdly__tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__wr_ptr;
    vlSelfRef.tb_fifo__DOT__full0 = ((0U == VL_SHIFTL_III(32,32,32, (IData)(vlSelfRef.tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__wr_ptr), 1U))
                                      ? (0x1fU == (IData)(vlSelfRef.tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__rd_ptr))
                                      : ((0x1fU & VL_SHIFTL_III(5,5,32, (IData)(vlSelfRef.tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__wr_ptr), 1U)) 
                                         == (IData)(vlSelfRef.tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__rd_ptr)));
    vlSelfRef.tb_fifo__DOT__empty0 = ((IData)(vlSelfRef.tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__wr_ptr) 
                                      == (IData)(vlSelfRef.tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__rd_ptr));
}

VL_INLINE_OPT void Vtb_fifo___024root___nba_comb__TOP__0(Vtb_fifo___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vtb_fifo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_fifo___024root___nba_comb__TOP__0\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.tb_fifo__DOT__deq_data0 = 0U;
    if ((1U & (IData)(vlSelfRef.tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__rd_ptr))) {
        vlSelfRef.tb_fifo__DOT__deq_data0 = vlSelfRef.tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data
            [0U];
    }
    if ((2U & (IData)(vlSelfRef.tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__rd_ptr))) {
        vlSelfRef.tb_fifo__DOT__deq_data0 = vlSelfRef.tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data
            [1U];
    }
    if ((4U & (IData)(vlSelfRef.tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__rd_ptr))) {
        vlSelfRef.tb_fifo__DOT__deq_data0 = vlSelfRef.tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data
            [2U];
    }
    if ((8U & (IData)(vlSelfRef.tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__rd_ptr))) {
        vlSelfRef.tb_fifo__DOT__deq_data0 = vlSelfRef.tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data
            [3U];
    }
    if ((0x10U & (IData)(vlSelfRef.tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__rd_ptr))) {
        vlSelfRef.tb_fifo__DOT__deq_data0 = vlSelfRef.tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data
            [4U];
    }
    vlSelfRef.tb_fifo__DOT__f0state_n = vlSelfRef.tb_fifo__DOT__f0state;
    vlSelfRef.tb_fifo__DOT__enq_data0 = 0U;
    vlSelfRef.tb_fifo__DOT__enq_valid0 = 0U;
    vlSelfRef.tb_fifo__DOT__deq_ready0 = 0U;
    vlSelfRef.tb_fifo__DOT__value_n = vlSelfRef.tb_fifo__DOT__value;
    if ((0x10U & (IData)(vlSelfRef.tb_fifo__DOT__f0state))) {
        if (VL_UNLIKELY((8U & (IData)(vlSelfRef.tb_fifo__DOT__f0state)))) {
            VL_FINISH_MT("tb_fifo.sv", 170, "");
            VL_STOP_MT("tb_fifo.sv", 171, "");
        } else if ((4U & (IData)(vlSelfRef.tb_fifo__DOT__f0state))) {
            if (VL_UNLIKELY((2U & (IData)(vlSelfRef.tb_fifo__DOT__f0state)))) {
                VL_FINISH_MT("tb_fifo.sv", 170, "");
                VL_STOP_MT("tb_fifo.sv", 171, "");
            } else if (VL_LIKELY((1U & (IData)(vlSelfRef.tb_fifo__DOT__f0state)))) {
                VL_FINISH_MT("tb_fifo.sv", 170, "");
                VL_STOP_MT("tb_fifo.sv", 171, "");
            } else {
                VL_WRITEF_NX("ERROR\n\n",0);
                VL_FINISH_MT("tb_fifo.sv", 165, "");
                VL_STOP_MT("tb_fifo.sv", 166, "");
            }
        } else if (VL_LIKELY((2U & (IData)(vlSelfRef.tb_fifo__DOT__f0state)))) {
            if (VL_UNLIKELY((1U & (IData)(vlSelfRef.tb_fifo__DOT__f0state)))) {
                VL_WRITEF_NX("GOOD\n\n",0);
                VL_FINISH_MT("tb_fifo.sv", 160, "");
                VL_STOP_MT("tb_fifo.sv", 161, "");
            } else {
                VL_FINISH_MT("tb_fifo.sv", 170, "");
                VL_STOP_MT("tb_fifo.sv", 171, "");
            }
        } else {
            VL_FINISH_MT("tb_fifo.sv", 170, "");
            VL_STOP_MT("tb_fifo.sv", 171, "");
        }
    } else if (VL_UNLIKELY((8U & (IData)(vlSelfRef.tb_fifo__DOT__f0state)))) {
        VL_FINISH_MT("tb_fifo.sv", 170, "");
        VL_STOP_MT("tb_fifo.sv", 171, "");
    } else if ((4U & (IData)(vlSelfRef.tb_fifo__DOT__f0state))) {
        if (VL_UNLIKELY((2U & (IData)(vlSelfRef.tb_fifo__DOT__f0state)))) {
            VL_FINISH_MT("tb_fifo.sv", 170, "");
            VL_STOP_MT("tb_fifo.sv", 171, "");
        } else if ((1U & (IData)(vlSelfRef.tb_fifo__DOT__f0state))) {
            vlSelfRef.tb_fifo__DOT__deq_ready0 = 1U;
            if ((((~ (IData)(vlSelfRef.tb_fifo__DOT__empty0)) 
                  & (~ (IData)(vlSelfRef.tb_fifo__DOT__full0))) 
                 & ((IData)(vlSelfRef.tb_fifo__DOT__deq_data0) 
                    == (IData)(vlSelfRef.tb_fifo__DOT__value)))) {
                vlSelfRef.tb_fifo__DOT__value_n = (0x3ffU 
                                                   & ((IData)(1U) 
                                                      + (IData)(vlSelfRef.tb_fifo__DOT__value)));
                vlSelfRef.tb_fifo__DOT__f0state_n = 
                    ((4U != (IData)(vlSelfRef.tb_fifo__DOT__value))
                      ? 5U : 0x13U);
            } else {
                vlSelfRef.tb_fifo__DOT__f0state_n = 0x14U;
            }
        } else {
            vlSelfRef.tb_fifo__DOT__deq_ready0 = 1U;
            if ((((~ (IData)(vlSelfRef.tb_fifo__DOT__empty0)) 
                  & (IData)(vlSelfRef.tb_fifo__DOT__full0)) 
                 & ((IData)(vlSelfRef.tb_fifo__DOT__deq_data0) 
                    == (IData)(vlSelfRef.tb_fifo__DOT__value)))) {
                vlSelfRef.tb_fifo__DOT__value_n = 2U;
                vlSelfRef.tb_fifo__DOT__f0state_n = 5U;
            } else {
                vlSelfRef.tb_fifo__DOT__f0state_n = 0x14U;
            }
        }
    } else if ((2U & (IData)(vlSelfRef.tb_fifo__DOT__f0state))) {
        if ((1U & (IData)(vlSelfRef.tb_fifo__DOT__f0state))) {
            vlSelfRef.tb_fifo__DOT__enq_data0 = vlSelfRef.tb_fifo__DOT__value;
            vlSelfRef.tb_fifo__DOT__value_n = (0x3ffU 
                                               & ((IData)(1U) 
                                                  + (IData)(vlSelfRef.tb_fifo__DOT__value)));
            vlSelfRef.tb_fifo__DOT__enq_valid0 = 1U;
            vlSelfRef.tb_fifo__DOT__deq_ready0 = 0U;
            if ((4U == (IData)(vlSelfRef.tb_fifo__DOT__value))) {
                vlSelfRef.tb_fifo__DOT__value_n = 1U;
                vlSelfRef.tb_fifo__DOT__f0state_n = 4U;
            } else {
                vlSelfRef.tb_fifo__DOT__f0state_n = 3U;
            }
        } else {
            vlSelfRef.tb_fifo__DOT__deq_ready0 = 1U;
            vlSelfRef.tb_fifo__DOT__f0state_n = ((IData)(
                                                         (((1U 
                                                            == (IData)(vlSelfRef.tb_fifo__DOT__deq_data0)) 
                                                           & (~ (IData)(vlSelfRef.tb_fifo__DOT__empty0))) 
                                                          & (~ (IData)(vlSelfRef.tb_fifo__DOT__full0))))
                                                  ? 3U
                                                  : 0x14U);
        }
    } else if ((1U & (IData)(vlSelfRef.tb_fifo__DOT__f0state))) {
        vlSelfRef.tb_fifo__DOT__enq_data0 = 1U;
        vlSelfRef.tb_fifo__DOT__enq_valid0 = 1U;
        vlSelfRef.tb_fifo__DOT__f0state_n = 2U;
    } else {
        vlSelfRef.tb_fifo__DOT__value_n = 1U;
        vlSelfRef.tb_fifo__DOT__f0state_n = 1U;
    }
}

void Vtb_fifo___024root___eval_triggers__act(Vtb_fifo___024root* vlSelf);

bool Vtb_fifo___024root___eval_phase__act(Vtb_fifo___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vtb_fifo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_fifo___024root___eval_phase__act\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    VlTriggerVec<2> __VpreTriggered;
    CData/*0:0*/ __VactExecute;
    // Body
    Vtb_fifo___024root___eval_triggers__act(vlSelf);
    __VactExecute = vlSelfRef.__VactTriggered.any();
    if (__VactExecute) {
        __VpreTriggered.andNot(vlSelfRef.__VactTriggered, vlSelfRef.__VnbaTriggered);
        vlSelfRef.__VnbaTriggered.thisOr(vlSelfRef.__VactTriggered);
        Vtb_fifo___024root___eval_act(vlSelf);
    }
    return (__VactExecute);
}

bool Vtb_fifo___024root___eval_phase__nba(Vtb_fifo___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vtb_fifo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_fifo___024root___eval_phase__nba\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    CData/*0:0*/ __VnbaExecute;
    // Body
    __VnbaExecute = vlSelfRef.__VnbaTriggered.any();
    if (__VnbaExecute) {
        Vtb_fifo___024root___eval_nba(vlSelf);
        vlSelfRef.__VnbaTriggered.clear();
    }
    return (__VnbaExecute);
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtb_fifo___024root___dump_triggers__nba(Vtb_fifo___024root* vlSelf);
#endif  // VL_DEBUG
#ifdef VL_DEBUG
VL_ATTR_COLD void Vtb_fifo___024root___dump_triggers__act(Vtb_fifo___024root* vlSelf);
#endif  // VL_DEBUG

void Vtb_fifo___024root___eval(Vtb_fifo___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vtb_fifo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_fifo___024root___eval\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    IData/*31:0*/ __VnbaIterCount;
    CData/*0:0*/ __VnbaContinue;
    // Body
    __VnbaIterCount = 0U;
    __VnbaContinue = 1U;
    while (__VnbaContinue) {
        if (VL_UNLIKELY((0x64U < __VnbaIterCount))) {
#ifdef VL_DEBUG
            Vtb_fifo___024root___dump_triggers__nba(vlSelf);
#endif
            VL_FATAL_MT("tb_fifo.sv", 3, "", "NBA region did not converge.");
        }
        __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
        __VnbaContinue = 0U;
        vlSelfRef.__VactIterCount = 0U;
        vlSelfRef.__VactContinue = 1U;
        while (vlSelfRef.__VactContinue) {
            if (VL_UNLIKELY((0x64U < vlSelfRef.__VactIterCount))) {
#ifdef VL_DEBUG
                Vtb_fifo___024root___dump_triggers__act(vlSelf);
#endif
                VL_FATAL_MT("tb_fifo.sv", 3, "", "Active region did not converge.");
            }
            vlSelfRef.__VactIterCount = ((IData)(1U) 
                                         + vlSelfRef.__VactIterCount);
            vlSelfRef.__VactContinue = 0U;
            if (Vtb_fifo___024root___eval_phase__act(vlSelf)) {
                vlSelfRef.__VactContinue = 1U;
            }
        }
        if (Vtb_fifo___024root___eval_phase__nba(vlSelf)) {
            __VnbaContinue = 1U;
        }
    }
}

#ifdef VL_DEBUG
void Vtb_fifo___024root___eval_debug_assertions(Vtb_fifo___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vtb_fifo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_fifo___024root___eval_debug_assertions\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if (VL_UNLIKELY((vlSelfRef.clk & 0xfeU))) {
        Verilated::overWidthError("clk");}
    if (VL_UNLIKELY((vlSelfRef.rst_n & 0xfeU))) {
        Verilated::overWidthError("rst_n");}
}
#endif  // VL_DEBUG
