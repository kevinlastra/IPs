// ============================================================
// Project      : UART IP
// Author       : Kevin Lastra
// Description  : UART (Universal Asynchronous Receiver/Transmitter) 
// 
// Revision     : 1.0.0
// 
// License      : MIT License
// ============================================================

// divider = clk_in / clk_out   
//       ex: 25 Mhz(25000000) / 9600 = 2604

// CSR : Control and Status Registers

module uart_csr
  import axi4_pkg::*;
  import uart_defs::*;
  #(
    parameter logic [31:0] REG_ADDR_MAP = 32'h0
  ) 
  (
    // System reset and clock
    input logic         clk,
    input logic         rst_n,
    
    // Bus
    axi4.slave          bus,

    // Uart registers
    output logic [31:0] divider_q_o,
    output logic [31:0] rxirqmask_q_o,
    output logic [31:0] txirqmask_q_o,
    output Config_t     uart_config_q_o,

    // TX interface
    output logic        tx_enable_o,
    output logic [7:0]  tx_d_o,
    output logic        tx_d_valid_o,

    // RX interface
    output logic        rx_enable_o,
    input  logic [7:0]  rx_d_i,
    input  logic        rx_d_valid_i,
    output logic        rx_d_ready_o,

    // RX & TX status
    input RXStatus_t    rx_status_i,
    input TXStatus_t    tx_status_i
  );

  REGState_t             state_d;
  REGState_t             state_q;

  logic                  wsel;
  logic                  rsel;

  logic [7:0]            tx_d_q;

  logic [31:0]           bus_rdata;
  logic [bus.idlen-1:0]  bus_id_d, bus_id_q;
  XRESP_t                bus_w_resp;
  XRESP_t                bus_r_resp;

  logic [31:0]           rxirqmask;
  logic [31:0]           txirqmask;
  Config_t               uart_config;
  logic [31:0]           divider;

  assign wsel = bus.aw_valid & bus.w_valid & {bus.aw.addr[31:12], 12'b0} == REG_ADDR_MAP;
  assign rsel = bus.ar_valid & {bus.ar.addr[31:12], 12'b0} == REG_ADDR_MAP;

  // Write REG
  always_comb begin
    bus_w_resp = OKAY;

    tx_d_valid_o = 0;

    case({wsel, bus.aw.addr[11:0]})
      DIVIDER : begin
        divider = bus.w.data;
      end
      TXDATA : begin
        tx_d_o = bus.w.data[7:0]; 
        tx_d_valid_o = 1;
      end
      RXIRQMASK : begin
        rxirqmask = bus.w.data;
      end
      TXIRQMASK : begin
        txirqmask = bus.w.data;
      end
      CONTROL : begin
        uart_config = $bits(Config_t)'(bus.w.data);
      end
      default: 
        bus_w_resp = SLVERR;
    endcase
  end

  // Read REG
  always_comb begin
    bus_r_resp = OKAY;

    case({rsel, bus.ar.addr[11:0]})
      DIVIDER : begin
        bus_rdata = divider_q_o;
      end
      RXDATA : begin
        bus_rdata = {24'b0, rx_d_i};
      end
      RXSTATUS : begin
        bus_rdata = 32'(rx_status_i);
      end
      RXIRQMASK : begin
        bus_rdata = rxirqmask_q_o;
      end
      TXDATA : begin
        bus_rdata = {24'h0, tx_d_q};
      end
      TXSTATUS : begin
        bus_rdata = 32'(tx_status_i);
      end
      TXIRQMASK : begin
        bus_rdata = txirqmask_q_o;
      end
      CONTROL : begin
        bus_rdata = {26'h0, uart_config_q_o};
      end
      VERSION : begin
        bus_rdata = {VERSION_MAJOR, VERSION_MINOR, VERSION_PATCHES};
      end
      default: 
        bus_r_resp = SLVERR;
    endcase 
  end

  always_comb begin
    state_d = state_q;

    bus_id_d = bus_id_q;

    bus.ar_ready = 0;
    bus.aw_ready = 0;
    bus.w_ready = 0;

    bus.r       = '0;
    bus.r_valid = 0;

    bus.b       = '0;
    bus.b_valid = 0;

    case(state_q)
      REG_RST : begin
        state_d = REG_IDLE;
      end
      REG_IDLE : begin
        if(bus.aw_valid && bus.w_valid) begin
          bus.aw_ready = 1;
          bus.w_ready = 1;

          bus_id_d = bus.aw.id;
          
          state_d = REG_BRESP;
        end else if(bus.ar_valid) begin
          bus.ar_ready = 1;

          bus_id_d = bus.ar.id;
          
          state_d = REG_RRESP;
        end
      end 
      REG_RRESP : begin
        bus.r_valid = 1;
        bus.r.last  = 1;
        bus.r.data  = bus_rdata;
        bus.r.resp  = bus_r_resp;
        bus.r.id    = bus_id_q;
        if(bus.r_ready)
          state_d = REG_IDLE;
      end
      REG_BRESP : begin
        bus.b_valid = 1;
        bus.b.resp  = bus_w_resp;
        bus.b.id    = bus_id_q;
        if(bus.b_ready)
          state_d = REG_IDLE;
      end
      default: 
        state_d = REG_IDLE;
    endcase
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      divider_q_o     <= '0;
      rxirqmask_q_o   <= '0;
      txirqmask_q_o   <= '0;
      uart_config_q_o <= '0;
      bus_id_q        <= 0;

      state_q <= REG_RST;
    end else begin
      bus_id_q        <= bus_id_d;
      divider_q_o     <= divider;
      rxirqmask_q_o   <= rxirqmask;
      txirqmask_q_o   <= txirqmask;
      uart_config_q_o <= uart_config;

      state_q <= state_d;
    end
  end

  assign tx_enable_o = uart_config_q_o.mode == FULLDUPLEX 
                     | uart_config_q_o.mode == HALFDUPLEX
                     | (uart_config_q_o.mode == SIMPLEX & uart_config_q_o.master);

  assign rx_enable_o = uart_config_q_o.mode == FULLDUPLEX 
                     | uart_config_q_o.mode == HALFDUPLEX
                     | (uart_config_q_o.mode == SIMPLEX & ~uart_config_q_o.master);                     

endmodule

