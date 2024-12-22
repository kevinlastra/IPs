

module 
  #(
    parameter int map = 0;
  ) 
    uart_reg
  (
    // System reset and clock
    input logic rst_n,
    input logic clk,
    
    // Bus
    axi4 bus,

    // Uart
    input uart_bus_i_t uart_bus_i,
    output uart_bus_o_t uart_bus_o

    output logic [31:0] uart_divider,
    output logic [31:0] uart_txdata,
    output logic [31:0] uart_irqmask,

    input logic [31:0] uart_rxdata,
    input logic        uart_rxdata_valid,
    input logic        uart_rxdata_ready,
    input logic [31:0] uart_rxstatus,
    input logic [31:0] uart_txstatus,
    input logic [31:0] uart_status
  );

  enum bit[1:0] 
  {  
    IDLE = 0,
    RRESP = 1,
    BRESP = 2
  } State_t;

  State_t state, state_n;

  // divider = clk_in / clk_out   
  //       ex: 25 Mhz(25000000) / 9600 = 2604
  logic [31:0] divider, divider_n;
  logic [31:0] txdata, txdata_n;
  logic [31:0] irqmask, irqmask_n;

  logic [xlen-1:0]      bus_rdata;
  logic [alen-1:0]      bus_addr;
  logic [bus.idlen-1:0] bus_id;
  XRESP_t               bus_aw_resp;
  XRESP_t               bus_ar_resp;

  assign uart_divider = divider;
  assign uart_txdata  = txdata;
  assign uart_irqmask = irqmask;

  always_comb begin
    bus_w_resp = OKAY;

    casex (bus.aw.addr[7:0])
      DIVIDER_ADR : begin
        divider_n = bus.w.data;
      end
      TXDATA_ADR : begin
        txdata_n = bus.w.data;
      end
      IRQMASK_ADR : begin
        irqmask_n = bus.w.data;
      end
      default: 
        bus_w_resp = SLVERR;
    endcase
  end

  always_comb begin
    bus_r_resp = OKAY;

    casex (bus.ar.addr)
      DIVIDER_ADR : begin
        rdata = divider;
      end
      RXDATA_ADR : begin
        rdata = uart_rxdata;
      end
      RXSTATUS_ADR : begin
        rdata = uart_rxstatus;
      end
      TXDATA_ADR : begin
        rdata = txdata;
      end
      TXSTATUS_ADR : begin
        rdata = uart_txstatus;
      end
      IRQMASK_ADR : begin
        rdata = irqmask;
      end
      UART_STATUS_ADR : begin
        rdata = uart_status;
      end
      VERSION_ADR : begin
        rdata = {VERSION_MAJOR, VERSION_MINOR, VERSION_PATCHES};
      end
      default: 
        bus_r_resp = SLVERR;
    endcase  
  end

  always_comb begin
    state_n = state;

    bus_id = bus.ar.id;
    bus_addr = bus.aw.addr;

    casex (state)
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
    endcase
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      state <= IDLE;
    end else begin
      state <= state_n;
    end
  end

endmodule

