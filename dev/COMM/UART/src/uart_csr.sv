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

// Name      Access Type    Adresse
// Divider        RW          0x00
// RXData         RO          0x04
// RXStatus       RO          0x08
// RXIrqMask      RW          0x0C
// TXData         WO          0x10
// TXStatus       RO          0x14
// TXIrqMask      RW          0x18
// Control        RW          0x1C
// Version        RO          0x20
 
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
    output logic [8:0]  tx_d_o,
    output logic        tx_d_valid_o,

    // RX interface
    output logic        rx_enable_o,
    input  logic [8:0]  rx_d_i,
    input  logic        rx_d_valid_i,
    output logic        rx_d_ready_o,

    // RX & TX status
    input RXStatus_t    rx_status_i,
    input TXStatus_t    tx_status_i
  );

  REGState_t             state_d;
  REGState_t             state_q;

  logic                  wr;
  logic                  rd;
  logic                  sel;

  // CSRs
  logic                  rd_divider;
  logic                  wr_divider;
  logic                  rd_rxdata;
  logic                  rd_rxstatus;
  logic                  rd_rxirqmask;
  logic                  wr_rxirqmask;
  logic                  wr_txdata;
  logic                  rd_txstatus;
  logic                  rd_txirqmask;
  logic                  wr_txirqmask;
  logic                  rd_control;
  logic                  wr_control;
  logic                  rd_version;

  logic [31:0]           bus_addr_d, bus_addr_q;
  logic [31:0]           bus_wdata_d, bus_wdata_q;
  logic [31:0]           bus_rdata_d, bus_rdata_q;
  logic [bus.idlen-1:0]  bus_id_d, bus_id_q;

  logic [31:0]           rxirqmask;
  logic [31:0]           txirqmask;
  Config_t               cast_config, cast_config_n;

  assign sel = REG_ADDR_MAP == {bus_addr_d[31:12], 12'b0};

  assign rd_divider   = rd & sel & bus_addr_d[11:0] == DIVIDER;
  assign wr_divider   = wr & sel & bus_addr_d[11:0] == DIVIDER;
  assign rd_rxdata    = rd & sel & bus_addr_d[11:0] == RXDATA;
  assign rd_rxstatus  = rd & sel & bus_addr_d[11:0] == RXSTATUS;
  assign rd_rxirqmask = rd & sel & bus_addr_d[11:0] == RXIRQMASK;
  assign wr_rxirqmask = wr & sel & bus_addr_d[11:0] == RXIRQMASK;
  assign wr_txdata    = wr & sel & bus_addr_d[11:0] == TXDATA;
  assign rd_txstatus  = rd & sel & bus_addr_d[11:0] == TXSTATUS;
  assign rd_txirqmask = rd & sel & bus_addr_d[11:0] == TXIRQMASK;
  assign wr_txirqmask = wr & sel & bus_addr_d[11:0] == TXIRQMASK;
  assign rd_control   = rd & sel & bus_addr_d[11:0] == CONTROL;
  assign wr_control   = wr & sel & bus_addr_d[11:0] == CONTROL;
  assign rd_version   = rd & sel & bus_addr_d[11:0] == VERSION;

  // Divider register
  always_ff @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
      divider_q_o <= 0;    
    end else begin
      if(wr_divider) begin
        divider_q_o <= $bits(divider_q_o)'(bus_wdata_d);
      end
    end
  end

  // RX Irq Mask register
  always_ff @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
      rxirqmask_q_o <= 0;    
    end else begin
      if(wr_rxirqmask) begin
        rxirqmask_q_o <= $bits(rxirqmask_q_o)'(bus_wdata_d[$bits(RXStatus_t)-1:0]);
      end
    end
  end

  // Write data on TX asyncronous FIFO
  assign tx_d_o = $bits(tx_d_o)'(bus_wdata_d);
  assign tx_d_valid_o  = wr_txdata;

  // Write TX Irq Mask register
  always_ff @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
      txirqmask_q_o <= 0;
    end else begin
      if(wr_txirqmask) begin
        txirqmask_q_o <= $bits(txirqmask_q_o)'(bus_wdata_d[$bits(TXStatus_t)-1:0]);
      end
    end
  end

  // Write Uart configuration register
  always_comb begin
    cast_config_n = cast_config;
    if($countones(cast_config.frame_len) != 1) begin
      cast_config_n.frame_len = 5'h1;  
    end
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
      cast_config     <= 0;
      uart_config_q_o <= 0;
    end else begin
      if(wr_control) begin
        cast_config <= $bits(cast_config)'(bus_wdata_d[$bits(Config_t)-1:0]);
      end
      uart_config_q_o <= cast_config_n;
    end
  end

  // Read valid CSRs
  always_comb begin
    if (rd_divider) begin
      bus_rdata_d = divider_q_o;
    end else if(rd_rxdata) begin
      bus_rdata_d = $bits(bus_rdata_d)'(rx_d_i);
    end else if(rd_rxstatus) begin
      bus_rdata_d = $bits(bus_rdata_d)'(rx_status_i);
    end else if(rd_rxirqmask) begin
      bus_rdata_d = $bits(bus_rdata_d)'(rxirqmask_q_o);
    end else if(rd_txstatus) begin
      bus_rdata_d = $bits(bus_rdata_d)'(tx_status_i);
    end else if(rd_txirqmask) begin
      bus_rdata_d = $bits(bus_rdata_d)'(txirqmask_q_o);
    end else if(rd_control) begin
      bus_rdata_d = $bits(bus_rdata_d)'(uart_config_q_o);
    end else if(rd_version) begin
      bus_rdata_d = {VERSION_MAJOR, VERSION_MINOR, VERSION_PATCHES};
    end else begin
      bus_rdata_d = 0;
    end
  end

  always_comb begin
    state_d = state_q;
    
    bus_id_d = bus_id_q;
    bus_addr_d = 0;
    bus_wdata_d = 0;

    bus.ar_ready = 0;
    bus.aw_ready = 0;
    bus.w_ready = 0;

    bus.r       = '0;
    bus.r_valid = 0;

    bus.b       = '0;
    bus.b_valid = 0;

    wr = 0;
    rd = 0;

    case(state_q)
      CSR_RST : begin
        state_d = CSR_IDLE;
      end
      CSR_IDLE : begin
        if(bus.ar_valid) begin
          rd = 1;
          bus.ar_ready = 1;

          bus_addr_d = bus.ar.addr;
          bus_id_d = bus.ar.id;
          
          state_d = CSR_RRESP;
        end else if(bus.aw_valid && bus.w_valid) begin
          wr = 1;
          bus.aw_ready = 1;
          bus.w_ready = 1;

          bus_addr_d = bus.aw.addr;
          bus_wdata_d = bus.w.data;
          bus_id_d = bus.aw.id;
          
          state_d = CSR_BRESP;
        end else if(bus.aw_valid)  begin
          bus.aw_ready = 1;

          bus_id_d = bus.aw.id;
          bus_addr_d = bus.aw.addr;

          state_d = CSR_WW;
        end else if(bus.w_valid)  begin
          bus_wdata_d = bus.w.data;

          state_d = CSR_WAW;
        end
      end 
      CSR_WW : begin
        bus_id_d = bus_id_q;
        bus_addr_d = bus_addr_q;

        if(bus.w_valid) begin
          bus.w_ready = 1;

          wr = 1;

          state_d = CSR_BRESP;
        end
      end
      CSR_WAW : begin
        if(bus.aw_valid) begin
          bus.aw_ready = 1;

          bus_id_d = bus.aw.id;
          bus_addr_d = bus.aw.addr;
          bus_wdata_d = bus_wdata_q;

          wr = 1;

          state_d = CSR_BRESP;
        end
      end
      CSR_RRESP : begin
        bus.r_valid = 1;
        bus.r.last  = 1;
        bus.r.data  = bus_rdata_q;
        bus.r.resp  = bus_addr_q > VERSION ? SLVERR : OKAY;
        bus.r.id    = bus_id_q;
        if(bus.r_ready)
          state_d = CSR_IDLE;
      end
      CSR_BRESP : begin
        bus.b_valid = 1;
        bus.b.resp  = bus_addr_q > VERSION ? SLVERR : OKAY;
        bus.b.id    = bus_id_q;
        if(bus.b_ready)
          state_d = CSR_IDLE;
      end
      default: 
        state_d = CSR_IDLE;
    endcase
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      bus_id_q   <= 0;
      bus_addr_q <= 0;
      bus_wdata_q <= 0;
      bus_rdata_q <= 0;
      state_q    <= CSR_RST;
    end else begin
      bus_id_q   <= bus_id_d;
      bus_addr_q <= bus_addr_d;
      bus_wdata_q <= bus_wdata_d;
      bus_rdata_q <= bus_rdata_d;
      state_q    <= state_d;
    end
  end

  assign tx_enable_o = uart_config_q_o.mode == FULLDUPLEX 
                     | uart_config_q_o.mode == HALFDUPLEX
                     | (uart_config_q_o.mode == SIMPLEX & uart_config_q_o.master);

  assign rx_enable_o = uart_config_q_o.mode == FULLDUPLEX 
                     | uart_config_q_o.mode == HALFDUPLEX
                     | (uart_config_q_o.mode == SIMPLEX & ~uart_config_q_o.master);                     

endmodule

