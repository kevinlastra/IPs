

  // divider = clk_in / clk_out   
  //       ex: 25 Mhz(25000000) / 9600 = 2604

module uart_reg
  import axi4_pkg::*;
  import uart_defs::*;
  #(
    parameter logic [31:0] regmap = 32'h0
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
    output logic [7:0]  tx_d_o,
    output logic        tx_d_valid_o,

    // RX interface
    input  logic [7:0]  rx_d_i,
    input  logic        rx_d_valid_i,
    output logic        rx_d_ready_o,

    // RX & TX status
    input logic [31:0]  rx_status_i,
    input logic [31:0]  tx_status_i
  );

  typedef enum bit[1:0] 
  {  
    IDLE = 0,
    RRESP = 1,
    BRESP = 2
  } State_t;

  State_t               state;
  State_t               state_q;

  logic                  wsel;
  logic                  rsel;

  logic [7:0]            tx_d_q;

  logic [31:0]           bus_rdata;
  logic [31:0]           bus_addr;
  logic [bus.idlen-1:0]  bus_id;
  XRESP_t                bus_w_resp;
  XRESP_t                bus_r_resp;

  logic [31:0]           rxirqmask;
  logic [31:0]           txirqmask;
  Config_t               uart_config;
  logic [31:0]           divider;

  assign wsel = bus.aw_valid & bus.w_valid & {bus.aw.addr[31:12], 12'b0} == regmap;
  assign rsel = bus.ar_valid & {bus.ar.addr[31:12], 12'b0} == regmap;

  // Write REG
  always_comb begin
    bus_w_resp = OKAY;

    case({wsel, bus.aw.addr[11:0]})
      DIVIDER : begin
        divider = bus.w.data;
      end
      TXDATA : begin
        tx_d_o = bus.w.data[7:0];
        tx_d_valid_o = 1;
      end
      RXIRQMASK : begin
        rxirqmask = {26'b0, bus.w.data[$size(RXIrqFlags_t)-1:0]};
      end
      TXIRQMASK : begin
        txirqmask = {29'b0, bus.w.data[$size(TXIrqFlags_t)-1:0]};
      end
      STATUS : begin
        uart_config = bus.w.data[$size(Config_t)-1:0];
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
        bus_rdata = rx_status_i;
      end
      RXIRQMASK : begin
        bus_rdata = rxirqmask_q_o;
      end
      TXDATA : begin
        bus_rdata = {24'h0, tx_d_q};
      end
      TXSTATUS : begin
        bus_rdata = tx_status_i;
      end
      TXIRQMASK : begin
        bus_rdata = txirqmask_q_o;
      end
      STATUS : begin
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
    state_q = state;

    bus_id = bus.ar.id;
    bus_addr = bus.aw.addr;

    case(state)
      IDLE : begin
        if(bus.aw_valid && bus.w_valid) begin
          bus.aw_ready = 1;
          bus.w_ready = 1;
          
          state_q = BRESP;
        end else if(bus.ar_valid) begin
          bus.ar_ready = 1;
          
          state_q = RRESP;
        end
      end 
      RRESP : begin
        bus.r_valid = 1;
        bus.r.last  = 1;
        bus.r.data  = bus_rdata;
        bus.r.resp  = bus_r_resp;
        bus.r.id    = bus_id;
        if(bus.r_ready)
          state_q = IDLE;
      end
      BRESP : begin
        bus.b_valid = 1;
        bus.b.resp  = bus_w_resp;
        bus.b.id    = bus_id;
        if(bus.b_ready)
          state_q = IDLE;
      end
      default: 
        state_q = IDLE;
    endcase
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      divider_q_o <= '0;
      tx_d_q  <= '0;
      rxirqmask_q_o <= '0;
      txirqmask_q_o <= '0;
      uart_config_q_o <= '0;

      state <= IDLE;
    end else begin
      divider_q_o <= divider;
      rxirqmask_q_o <= rxirqmask;
      txirqmask_q_o <= txirqmask;
      uart_config_q_o <= uart_config;

      if(tx_d_valid_o)
        tx_d_q  <= tx_d_o;

      state <= state_q;
    end
  end

endmodule

