

// UART implementation

module uart
  import uart_defs::*;
  #(
    parameter logic [31:0] regmap = 32'h0
  ) 
  (
    // System reset and clock
    input logic clk,
    input logic rst_n,
    
    // UART interface
    input  logic rx,
    output logic tx,
`ifdef VERILATOR
    input  logic rts_in_n,
    output logic rts_out_n,

    input  logic cts_in_n,
    output logic cts_out_n,
`else 
    inout logic rts_n,
    inout logic cts_n,
`endif

    // System interface
    axi4.slave bus,

    output logic wakeup,
    output logic rx_irq,
    output logic tx_irq
  );

  // Uart clock
  logic tck;

  logic [31:0] counter;

  logic [31:0] uart_divider;
  logic [7:0]  uart_txdata;
  logic        uart_txdata_valid;
  logic [31:0] uart_rxirqmask;
  logic [31:0] uart_txirqmask;
  logic [7:0]  uart_rxdata;
  logic        uart_rxdata_valid;
  logic        uart_rxdata_ready;

  Config_t     uart_config;

  logic        rxfifo_full;
  logic        rxfifo_empty;
  logic        rx_wakeup;
  logic [31:0] rx_status;
  RXIrqFlags_t rx_irq_flags;
  
  logic        txfifo_full;
  logic        txfifo_empty;
  logic [31:0] tx_status;
  TXIrqFlags_t tx_irq_flags;

  logic        error_parity;

  logic        rx_cts_n;
  logic        rx_rts_n;

  logic        tx_cts_n;
  logic        tx_rts_n;

  uart_reg #(.regmap(regmap)) reg_i
  (
    .clk               (clk),
    .rst_n             (rst_n),
    .bus               (bus),
    .uart_divider      (uart_divider),
    .uart_txdata       (uart_txdata),
    .uart_txdata_valid (uart_txdata_valid),
    .uart_rxirqmask    (uart_rxirqmask),
    .uart_txirqmask    (uart_txirqmask),
    .uart_config       (uart_config),
    .uart_rxdata       (uart_rxdata),
    .uart_rxdata_valid (uart_rxdata_valid),
    .uart_rxdata_ready (uart_rxdata_ready),
    .uart_rxstatus     (rx_status),
    .uart_rxirqflags   (rx_irq_flags),
    .uart_txstatus     (tx_status),
    .uart_txirqflags   (tx_irq_flags)
  );
  
  uart_rx rx_i 
  (
    .clk              (clk),
    .rst_n            (rst_n),
    .tck              (tck),
    .rx               (rx),
    .rx_rts_n         (rx_rts_n),
    .rx_cts_n         (rx_cts_n),
    .rxfifo_data      (uart_rxdata),
    .rxfifo_valid     (uart_rxdata_valid),
    .rxfifo_ready     (uart_rxdata_ready),
    .rxfifo_full      (rxfifo_full),
    .rxfifo_empty     (rxfifo_empty),
    .error_parity     (error_parity),
    .wakeup           (wakeup),
    .rx_irq_flags     (rx_irq_flags),
    .uart_config      (uart_config)
  );

  uart_tx tx_i 
  (
    .clk              (clk),
    .rst_n            (rst_n),
    .tck              (tck),
    .tx               (tx),
    .tx_rts_n         (tx_rts_n),
    .tx_cts_n         (tx_cts_n),
    .txdata           (uart_txdata),
    .txdata_valid     (uart_txdata_valid),
    .txfifo_full      (txfifo_full),
    .txfifo_empty     (txfifo_empty),
    .tx_irq_flags     (tx_irq_flags),
    .uart_config      (uart_config)
  );

  always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      counter <= 0;
      tck <= 0;
    end else begin
      counter <= counter + 1;
      if(counter >= (uart_divider/2)) begin
        tck <= !tck;
        counter <= 0;
      end
    end
  end

  assign rx_irq = |(rx_irq_flags & uart_rxirqmask[$bits(RXIrqFlags_t)-1:0]);
  assign tx_irq = |(tx_irq_flags & uart_txirqmask[$bits(TXIrqFlags_t)-1:0]);

  // R/TX status
  // [parity not equal, master transmitter, fifo full, fifo empty]
  assign rx_status = {28'h0, error_parity, 1'b0, rxfifo_full, rxfifo_empty};
  assign tx_status = {28'h0,         1'b0, 1'b1, txfifo_full, txfifo_empty};

`ifdef VERILATOR
  always_comb begin
    rts_out_n = 1'b1;
    cts_out_n = 1'b1;

    tx_cts_n = 1'b1;
    rx_rts_n = 1'b1;

    if(!tx_rts_n && rts_in_n) begin
      rts_out_n = tx_rts_n;
      tx_cts_n = cts_in_n;
    end else if(!rts_in_n && tx_rts_n) begin
      rx_rts_n = rts_in_n;
      cts_out_n = rx_cts_n;
    end
  end
`else
  // TODO: add PLL to handle inout port
  // ifdef VIVADO 
  // ifdef CADENCE
`endif
endmodule
