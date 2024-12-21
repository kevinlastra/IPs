// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtb_fifo.h for the primary calling header

#include "Vtb_fifo__pch.h"
#include "Vtb_fifo___024root.h"

VL_ATTR_COLD void Vtb_fifo___024root___eval_static(Vtb_fifo___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vtb_fifo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_fifo___024root___eval_static\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

VL_ATTR_COLD void Vtb_fifo___024root___eval_initial(Vtb_fifo___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vtb_fifo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_fifo___024root___eval_initial\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__Vtrigprevexpr___TOP__clk__0 = vlSelfRef.clk;
    vlSelfRef.__Vtrigprevexpr___TOP__rst_n__0 = vlSelfRef.rst_n;
}

VL_ATTR_COLD void Vtb_fifo___024root___eval_final(Vtb_fifo___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vtb_fifo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_fifo___024root___eval_final\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtb_fifo___024root___dump_triggers__stl(Vtb_fifo___024root* vlSelf);
#endif  // VL_DEBUG
VL_ATTR_COLD bool Vtb_fifo___024root___eval_phase__stl(Vtb_fifo___024root* vlSelf);

VL_ATTR_COLD void Vtb_fifo___024root___eval_settle(Vtb_fifo___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vtb_fifo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_fifo___024root___eval_settle\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    IData/*31:0*/ __VstlIterCount;
    CData/*0:0*/ __VstlContinue;
    // Body
    __VstlIterCount = 0U;
    vlSelfRef.__VstlFirstIteration = 1U;
    __VstlContinue = 1U;
    while (__VstlContinue) {
        if (VL_UNLIKELY((0x64U < __VstlIterCount))) {
#ifdef VL_DEBUG
            Vtb_fifo___024root___dump_triggers__stl(vlSelf);
#endif
            VL_FATAL_MT("tb_fifo.sv", 3, "", "Settle region did not converge.");
        }
        __VstlIterCount = ((IData)(1U) + __VstlIterCount);
        __VstlContinue = 0U;
        if (Vtb_fifo___024root___eval_phase__stl(vlSelf)) {
            __VstlContinue = 1U;
        }
        vlSelfRef.__VstlFirstIteration = 0U;
    }
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtb_fifo___024root___dump_triggers__stl(Vtb_fifo___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vtb_fifo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_fifo___024root___dump_triggers__stl\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1U & (~ vlSelfRef.__VstlTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelfRef.__VstlTriggered.word(0U))) {
        VL_DBG_MSGF("         'stl' region trigger index 0 is active: Internal 'stl' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vtb_fifo___024root___stl_sequent__TOP__0(Vtb_fifo___024root* vlSelf);
VL_ATTR_COLD void Vtb_fifo___024root____Vm_traceActivitySetAll(Vtb_fifo___024root* vlSelf);

VL_ATTR_COLD void Vtb_fifo___024root___eval_stl(Vtb_fifo___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vtb_fifo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_fifo___024root___eval_stl\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1ULL & vlSelfRef.__VstlTriggered.word(0U))) {
        Vtb_fifo___024root___stl_sequent__TOP__0(vlSelf);
        Vtb_fifo___024root____Vm_traceActivitySetAll(vlSelf);
    }
}

VL_ATTR_COLD void Vtb_fifo___024root___stl_sequent__TOP__0(Vtb_fifo___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vtb_fifo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_fifo___024root___stl_sequent__TOP__0\n"); );
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
    vlSelfRef.tb_fifo__DOT__full0 = ((0U == VL_SHIFTL_III(32,32,32, (IData)(vlSelfRef.tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__wr_ptr), 1U))
                                      ? (0x1fU == (IData)(vlSelfRef.tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__rd_ptr))
                                      : ((0x1fU & VL_SHIFTL_III(5,5,32, (IData)(vlSelfRef.tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__wr_ptr), 1U)) 
                                         == (IData)(vlSelfRef.tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__rd_ptr)));
    vlSelfRef.tb_fifo__DOT__empty0 = ((IData)(vlSelfRef.tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__wr_ptr) 
                                      == (IData)(vlSelfRef.tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__rd_ptr));
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

VL_ATTR_COLD void Vtb_fifo___024root___eval_triggers__stl(Vtb_fifo___024root* vlSelf);

VL_ATTR_COLD bool Vtb_fifo___024root___eval_phase__stl(Vtb_fifo___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vtb_fifo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_fifo___024root___eval_phase__stl\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    CData/*0:0*/ __VstlExecute;
    // Body
    Vtb_fifo___024root___eval_triggers__stl(vlSelf);
    __VstlExecute = vlSelfRef.__VstlTriggered.any();
    if (__VstlExecute) {
        Vtb_fifo___024root___eval_stl(vlSelf);
    }
    return (__VstlExecute);
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtb_fifo___024root___dump_triggers__act(Vtb_fifo___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vtb_fifo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_fifo___024root___dump_triggers__act\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1U & (~ vlSelfRef.__VactTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelfRef.__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 0 is active: @(posedge clk)\n");
    }
    if ((2ULL & vlSelfRef.__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 1 is active: @(negedge rst_n)\n");
    }
}
#endif  // VL_DEBUG

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtb_fifo___024root___dump_triggers__nba(Vtb_fifo___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vtb_fifo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_fifo___024root___dump_triggers__nba\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1U & (~ vlSelfRef.__VnbaTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 0 is active: @(posedge clk)\n");
    }
    if ((2ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 1 is active: @(negedge rst_n)\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vtb_fifo___024root____Vm_traceActivitySetAll(Vtb_fifo___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vtb_fifo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_fifo___024root____Vm_traceActivitySetAll\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__Vm_traceActivity[0U] = 1U;
    vlSelfRef.__Vm_traceActivity[1U] = 1U;
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    vlSelfRef.__Vm_traceActivity[3U] = 1U;
}

VL_ATTR_COLD void Vtb_fifo___024root___ctor_var_reset(Vtb_fifo___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vtb_fifo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_fifo___024root___ctor_var_reset\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelf->clk = VL_RAND_RESET_I(1);
    vlSelf->rst_n = VL_RAND_RESET_I(1);
    vlSelf->tb_fifo__DOT__enq_data0 = VL_RAND_RESET_I(10);
    vlSelf->tb_fifo__DOT__enq_valid0 = VL_RAND_RESET_I(1);
    vlSelf->tb_fifo__DOT__deq_data0 = VL_RAND_RESET_I(10);
    vlSelf->tb_fifo__DOT__deq_ready0 = VL_RAND_RESET_I(1);
    vlSelf->tb_fifo__DOT__full0 = VL_RAND_RESET_I(1);
    vlSelf->tb_fifo__DOT__empty0 = VL_RAND_RESET_I(1);
    vlSelf->tb_fifo__DOT__value = VL_RAND_RESET_I(10);
    vlSelf->tb_fifo__DOT__value_n = VL_RAND_RESET_I(10);
    vlSelf->tb_fifo__DOT__f0state = 0;
    vlSelf->tb_fifo__DOT__f0state_n = 0;
    for (int __Vi0 = 0; __Vi0 < 5; ++__Vi0) {
        vlSelf->tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data[__Vi0] = VL_RAND_RESET_I(10);
    }
    vlSelf->tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__wr_ptr = VL_RAND_RESET_I(5);
    vlSelf->tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__rd_ptr = VL_RAND_RESET_I(5);
    vlSelf->tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__unnamedblk1__DOT__i = 0;
    vlSelf->tb_fifo__DOT__fifo_0_i__DOT____Vlvbound_hb0832a7a__0 = VL_RAND_RESET_I(10);
    vlSelf->__Vdly__tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__wr_ptr = VL_RAND_RESET_I(5);
    vlSelf->__Vtrigprevexpr___TOP__clk__0 = VL_RAND_RESET_I(1);
    vlSelf->__Vtrigprevexpr___TOP__rst_n__0 = VL_RAND_RESET_I(1);
    for (int __Vi0 = 0; __Vi0 < 4; ++__Vi0) {
        vlSelf->__Vm_traceActivity[__Vi0] = 0;
    }
}
