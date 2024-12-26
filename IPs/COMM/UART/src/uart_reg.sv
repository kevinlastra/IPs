

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
    input logic clk,
    input logic rst_n,
    
    // Bus
    axi4.slave bus,

    // Uart
    output logic [31:0] uart_divider,
    output logic [7:0]  uart_txdata,
    output logic        uart_txdata_valid,
    output logic [31:0] uart_rxirqmask,
    output logic [31:0] uart_txirqmask,
    output Config_t     uart_config,

    input logic [7:0]  uart_rxdata,
    input logic        uart_rxdata_valid,
    input logic        uart_rxdata_ready,

    input logic [31:0]  uart_rxstatus,
    input RXIrqFlags_t  uart_rxirqflags,

    input logic [31:0]  uart_txstatus,
    input TXIrqFlags_t  uart_txirqflags
  );

  typedef enum bit[1:0] 
  {  
    IDLE = 0,
    RRESP = 1,
    BRESP = 2
  } State_t;

  State_t state, state_n;

  logic wsel;
  logic rsel;

  logic [7:0] txdata;

  logic [31:0]          bus_rdata;
  logic [31:0]          bus_addr;
  logic [bus.idlen-1:0] bus_id;
  XRESP_t               bus_w_resp;
  XRESP_t               bus_r_resp;

  logic [31:0] rxirqmask_n;
  logic [31:0] txirqmask_n;
  Config_t     config_n;
  logic [31:0] divider_n;

  // Write REG
  always_comb begin
    bus_w_resp = OKAY;

    wsel = {bus.aw.addr[31:12], 12'b0} == regmap;

    if(bus.aw_valid && bus.w_valid && wsel) begin
      casez (bus.aw.addr[11:0])
        DIVIDER_ADR : begin
          divider_n = bus.w.data;
        end
        TXDATA_ADR : begin
          uart_txdata = bus.w.data[7:0];
          uart_txdata_valid = 1;
        end
        RXIRQMASK_ADR : begin
          rxirqmask_n = bus.w.data & UART_RXMASK_W_MASK;
        end
        TXIRQMASK_ADR : begin
          txirqmask_n = bus.w.data & UART_TXMASK_W_MASK;
        end
        UART_STATUS_ADR : begin
          config_n = bus.w.data[$size(Config_t)-1:0];
        end
        default: 
          bus_w_resp = SLVERR;
      endcase
    end
  end

  // Read REG
  always_comb begin
    bus_r_resp = OKAY;

    rsel = {bus.ar.addr[31:12], 12'b0} == regmap;

    if(bus.ar_valid && rsel) begin
      casez (bus.ar.addr[11:0])
        DIVIDER_ADR : begin
          bus_rdata = uart_divider;
        end
        RXDATA_ADR : begin
          bus_rdata = {24'b0, uart_rxdata};
        end
        RXSTATUS_ADR : begin
          bus_rdata = uart_rxstatus;
        end
        RXIRQMASK_ADR : begin
          bus_rdata = uart_rxirqmask;
        end
        TXDATA_ADR : begin
          bus_rdata = {24'h0, txdata};
        end
        TXSTATUS_ADR : begin
          bus_rdata = uart_txstatus;
        end
        TXIRQMASK_ADR : begin
          bus_rdata = uart_txirqmask;
        end
        UART_STATUS_ADR : begin
          bus_rdata = {26'h0, uart_config};
        end
        VERSION_ADR : begin
          bus_rdata = {VERSION_MAJOR, VERSION_MINOR, VERSION_PATCHES};
        end
        default: 
          bus_r_resp = SLVERR;
      endcase 
    end
  end

  always_comb begin
    state_n = state;

    bus_id = bus.ar.id;
    bus_addr = bus.aw.addr;

    casez (state)
      IDLE : begin
        if(bus.aw_valid && bus.w_valid) begin
          bus.aw_ready = 1;
          bus.w_ready = 1;
          
          state_n = BRESP;
        end else if(bus.ar_valid) begin
          bus.ar_ready = 1;
          
          state_n = RRESP;
        end
      end 
      RRESP : begin
        bus.r_valid = 1;
        bus.r.last = 1;
        bus.r.data = bus_rdata;
        bus.r.resp = bus_r_resp;
        bus.r.id   = bus_id;
        if(bus.r_ready)
          state_n = IDLE;
      end
      BRESP : begin
        bus.b_valid = 1;
        bus.b.resp = bus_w_resp;
        bus.b.id   = bus_id;
        if(bus.b_ready)
          state_n = IDLE;
      end
      default: 
        state_n = IDLE;
    endcase
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      uart_divider <= '0;
      txdata  <= '0;
      uart_rxirqmask <= '0;
      uart_txirqmask <= '0;
      uart_config <= '0;

      state <= IDLE;
    end else begin
      uart_divider <= divider_n;
      uart_rxirqmask <= rxirqmask_n;
      uart_txirqmask <= txirqmask_n;
      uart_config <= config_n;

      if(uart_txdata_valid)
        txdata  <= uart_txdata;

      state <= state_n;
    end
  end

endmodule

