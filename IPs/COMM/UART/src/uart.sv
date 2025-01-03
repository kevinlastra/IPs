

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
    output logic rts_n,
    input  logic cts_n,

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

  logic        rx_line;
  logic        rx_cts_n;
  logic        rx_rts_n;
  logic        rx_enable;

  logic        tx_line;
  logic        tx_cts_n;
  logic        tx_rts_n;
  logic        tx_enable;

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
    .uart_txstatus     (tx_status)
  );
  
  uart_rx rx_i 
  (
    .clk              (clk),
    .rst_n            (rst_n),
    .tck              (tck),
    .rx               (rx_line),
    .rx_rts_n         (rx_rts_n),
    .rx_cts_n         (rx_cts_n),
    .rx_enable        (rx_enable),
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
    .tx               (tx_line),
    .tx_rts_n         (tx_rts_n),
    .tx_cts_n         (tx_cts_n),
    .tx_enable        (tx_enable),
    .txdata           (uart_txdata),
    .txdata_valid     (uart_txdata_valid),
    .txfifo_full      (txfifo_full),
    .txfifo_empty     (txfifo_empty),
    .tx_irq_flags     (tx_irq_flags),
    .uart_config      (uart_config)
  );

  uart_flow_ctrl uart_fc_i
  (
    .tck              (tck),
    .rst_n            (rst_n),
    .rts_n            (rts_n),
    .cts_n            (cts_n),
    .tx_rts_n         (tx_rts_n),
    .tx_cts_n         (tx_cts_n),
    .tx_enable        (tx_enable),
    .rx_rts_n         (rx_rts_n),
    .rx_cts_n         (rx_cts_n),
    .rx_enable        (rx_enable),
    .uart_config      (uart_config)
  );

  always_comb begin : data_ctrl
    tx = 1;
    rx_line = 1;
    if(uart_config.mode == SIMPLEX ||
       uart_config.mode == HALFDUPLEX) begin
      if(uart_config.master)
        tx = tx_line;
      else
        rx_line = rx;
    end else if(uart_config.mode == FULLDUPLEX) begin
      tx = tx_line;
      rx_line = rx;
    end
  end

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

endmodule
