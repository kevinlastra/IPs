// ============================================================
// IP           : axi5_mem
// Author       : Kevin Lastra
// Description  : AXI5 memory controller
// 
// Revision     : 1.0.0
// 
// License      : MIT License
// ============================================================

module axi5_mem
  import axi5_pkg::*;
  #(
    parameter int base_addr = 0,
    parameter int size      = 1024
  )
  (
    // Global inputs
    input logic clk,
    input logic rst_n,

    axi5.slave axi
  );

  localparam int xlen = axi.xlen;
  localparam int alen = axi.alen;
  localparam int depth = size/xlen;
  localparam int adr_sz = $clog2(depth);
  typedef enum logic [1:0]
  {  
    IDLE = 0,
    RRESP = 1
  } State_t;

  State_t state, n_state;
  typedef struct packed {
    logic [axi.alen-1:0]  addr;
    AXSize_t              size;
    AXBurst_t             burst;
    logic [2:0]           prot;
    logic [axi.ilen-1:0]  id;
    logic [7:0]           len;
  } AX_t;

  AX_t                      ax, n_ax;

  logic                     we;
  logic                     en;
  logic [adr_sz-1:0]        addr;
  logic [xlen-1:0]          wdata;
  logic [xlen-1:0]          rdata;

  logic [7:0]               cnt, n_cnt;

  always_comb begin : blockName
    // FSM defaults
    n_state = state;
    n_ax = ax;
    n_cnt = cnt;

    // AXI defaults
    axi.aw_ready = 1'b0;
    axi.w_ready  = 1'b0;
    axi.ar_ready = 1'b0;
    axi.r        = '0;
    axi.r_valid  = 1'b0;
    axi.b        = '0;
    axi.b_valid  = 1'b0;

    // Memory defaults
    we    = 1'b0;
    en    = 1'b0;
    addr  = '0;
    wdata = '0;

    unique case (state)
      IDLE : begin
        if(axi.ar_valid) begin
          en = 1'b1;
          addr = axi.ar.addr[adr_sz+1:2];
          n_ax = axi.ar;
          n_cnt = 1;
          // Complete handshake
          axi.ar_ready = 1'b1;
          // Next state
          n_state = RRESP;
        end else if(axi.aw_valid & axi.w_valid) begin
          we = 1'b1;
          en = 1'b1;
          addr = axi.ar.addr[adr_sz+1:2];
          // TODO: strb
          wdata = axi.w.data;
          n_ax = axi.aw;
          // n_state = ??
        end else if(axi.aw_valid) begin
          // TODO
        end else if(axi.w_valid) begin
          // TODO
        end
      end
      RRESP : begin
        axi.r.last = cnt == ax.len;
        axi.r.data = rdata;
        axi.r.resp = OKAY;
        axi.r.id   = ax.id;
        axi.r_valid = 1'b1;
        if(axi.r_ready) begin
          n_state = axi.r.last ? IDLE : RRESP;
        end
      end
    endcase
  end

  always_ff @( posedge clk or negedge rst_n ) begin : fsm_ff
    if(~rst_n) begin
      state <= n_state;
      ax    <= '0;
      cnt   <= '0;
    end else begin
      state <= n_state;
      ax    <= n_ax;
      cnt   <= n_cnt;
    end
  end

  sram_sp #(.depth(depth), .width(xlen)) sram
  (
    .clk   (clk),
    .we    (we),
    .en    (en),
    .addr  (addr),
    .wdata (wdata),
    .rdata (rdata)
  );

endmodule
