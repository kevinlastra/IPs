

// UART implementation
// Simplex
// Master transmitter
// 0: Receive
// 1: Transmitte
// 2: Ready to send
// 3: Clear to send

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

  logic [31:0] uart_rxstatus;
  logic [31:0] uart_txstatus;
  logic [31:0] uart_status;

  logic        rxfifo_full;
  logic        rxfifo_empty;
  logic        rx_wakeup;
  RXIrqFlags_t rx_irq_flags;
  
  logic        txfifo_full;
  logic        txfifo_empty;
  TXIrqFlags_t tx_irq_flags;

  logic        error_parity;
  logic [1:0]  com_mode;
  logic        rxmaster;
  logic        txmaster;

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
    .uart_rxdata       (uart_rxdata),
    .uart_rxdata_valid (uart_rxdata_valid),
    .uart_rxdata_ready (uart_rxdata_ready),
    .uart_rxstatus     (uart_rxstatus),
    .uart_txstatus     (uart_txstatus),
    .uart_status       (uart_status)
  );
  
  uart_rx rx_i 
  (
    .clk              (clk),
    .rst_n            (rst_n),
    .tck              (tck),
    .rx               (rx),
    .rxfifo_data      (uart_rxdata),
    .rxfifo_valid     (uart_rxdata_valid),
    .rxfifo_ready     (uart_rxdata_ready),
    .rxfifo_full      (rxfifo_full),
    .rxfifo_empty     (rxfifo_empty),
    .error_parity     (error_parity),
    .wakeup           (wakeup),
    .rx_irq_flags     (rx_irq_flags)
  );

  uart_tx tx_i 
  (
    .clk              (clk),
    .rst_n            (rst_n),
    .tck              (tck),
    .tx               (tx),
    .rts_n            (rts_n),
    .cts_n            (cts_n),
    .txdata           (uart_txdata),
    .txdata_valid     (uart_txdata_valid),
    .txfifo_full      (txfifo_full),
    .txfifo_empty     (txfifo_empty),
    .tx_irq_flags     (tx_irq_flags)
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
  assign uart_rxstatus = {28'h0, error_parity, 1'b0, rxfifo_full, rxfifo_empty};
  assign uart_txstatus = {28'h0,         1'b0, 1'b1, txfifo_full, txfifo_empty};

  // UART status
  // [communication mode]
  assign uart_status   = {30'h0,     SIMPLEX};

endmodule
