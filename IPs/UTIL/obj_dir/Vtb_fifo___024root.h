// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vtb_fifo.h for the primary calling header

#ifndef VERILATED_VTB_FIFO___024ROOT_H_
#define VERILATED_VTB_FIFO___024ROOT_H_  // guard

#include "verilated.h"


class Vtb_fifo__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vtb_fifo___024root final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    VL_IN8(clk,0,0);
    VL_IN8(rst_n,0,0);
    CData/*0:0*/ tb_fifo__DOT__enq_valid0;
    CData/*0:0*/ tb_fifo__DOT__deq_ready0;
    CData/*0:0*/ tb_fifo__DOT__full0;
    CData/*0:0*/ tb_fifo__DOT__empty0;
    CData/*4:0*/ tb_fifo__DOT__f0state;
    CData/*4:0*/ tb_fifo__DOT__f0state_n;
    CData/*4:0*/ tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__wr_ptr;
    CData/*4:0*/ tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__rd_ptr;
    CData/*4:0*/ __Vdly__tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__wr_ptr;
    CData/*0:0*/ __VstlFirstIteration;
    CData/*0:0*/ __Vtrigprevexpr___TOP__clk__0;
    CData/*0:0*/ __Vtrigprevexpr___TOP__rst_n__0;
    CData/*0:0*/ __VactContinue;
    SData/*9:0*/ tb_fifo__DOT__enq_data0;
    SData/*9:0*/ tb_fifo__DOT__deq_data0;
    SData/*9:0*/ tb_fifo__DOT__value;
    SData/*9:0*/ tb_fifo__DOT__value_n;
    SData/*9:0*/ tb_fifo__DOT__fifo_0_i__DOT____Vlvbound_hb0832a7a__0;
    IData/*31:0*/ tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__unnamedblk1__DOT__i;
    IData/*31:0*/ __VactIterCount;
    VlUnpacked<SData/*9:0*/, 5> tb_fifo__DOT__fifo_0_i__DOT__nsize_buffer__DOT__data;
    VlUnpacked<CData/*0:0*/, 4> __Vm_traceActivity;
    VlTriggerVec<1> __VstlTriggered;
    VlTriggerVec<2> __VactTriggered;
    VlTriggerVec<2> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vtb_fifo__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vtb_fifo___024root(Vtb_fifo__Syms* symsp, const char* v__name);
    ~Vtb_fifo___024root();
    VL_UNCOPYABLE(Vtb_fifo___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
