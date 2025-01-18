

// UART implementation
// 

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
  logic        tck;

  logic [31:0] counter;

  // Logic
  logic        isfullduplex;  
  
  // Reg interface
  logic [31:0] uart_divider;
  logic [31:0] uart_rxirqmask;
  logic [31:0] uart_txirqmask;
  Config_t     uart_config;

  // RX interface
  logic        rx_line;
  logic        rx_cts_n;
  logic        rx_rts_n;
  logic        rx_enable;

  logic [31:0] rx_status;

  logic [7:0]  rx_data;
  logic        rx_data_valid;
  logic        rx_data_ready;

  logic        rxfifo_full;
  logic        rxfifo_empty;

  RXIrqFlags_t rx_irq_flags;

  logic        rx_wakeup;

  logic        parity_error;
  logic        frame_len_error;
  
  // TX interface
  logic        tx_line;
  logic        tx_cts_n;
  logic        tx_rts_n;
  logic        tx_enable;

  logic [7:0]  tx_data;
  logic        tx_data_valid;
  logic        tx_data_ready;

  logic        txfifo_full;
  logic        txfifo_empty;

  logic [31:0] tx_status;

  TXIrqFlags_t tx_irq_flags;

  // Reset Resync
  // Metastability handling

  logic        rst_ff0;
  logic        rst_ff1;
  logic        rst_resync;

  always_ff @(posedge clk or negedge rst_n) begin : reset_resync
    if(~rst_n) begin
      rst_ff0    <= 0;
      rst_ff1    <= 0;
      rst_resync <= 0;
    end else begin
      rst_ff0    <= 1;
      rst_ff1    <= rst_ff0;
      rst_resync <= rst_ff1;
    end
  end

  // UART registers
  uart_reg #(.regmap(regmap)) reg_inst
  (
    .clk             (clk),
    .rst_n           (rst_resync),
    .bus             (bus),
    .divider_q_o     (uart_divider),
    .rxirqmask_q_o   (uart_rxirqmask),
    .txirqmask_q_o   (uart_txirqmask),
    .uart_config_q_o (uart_config),
    .tx_d_o          (tx_data),
    .tx_d_valid_o    (tx_data_valid),
    .rx_d_i          (rx_data),
    .rx_d_valid_i    (rx_data_valid),
    .rx_d_ready_o    (rx_data_ready),
    .rx_status_i     (rx_status),
    .tx_status_i     (tx_status)
  );
  
  // UART receiver
  uart_rx rx_inst
  (
    .clk               (clk),
    .rst_n             (rst_resync),
    .tck               (tck),
    .rx_i              (rx_line),
    .rx_rts_n_i        (rx_rts_n),
    .rx_cts_n_o        (rx_cts_n),
    .rx_enable_i       (rx_enable),
    .rx_d_o            (rx_data),
    .rx_d_valid_o      (rx_data_valid),
    .rx_d_ready_i      (rx_data_ready),
    .rx_full_o         (rxfifo_full),
    .rx_empty_o        (rxfifo_empty),
    .parity_error_o    (parity_error),
    .frame_len_error_o (frame_len_error),
    .wakeup_o          (wakeup),
    .rx_irq_flags_o    (rx_irq_flags),
    .uart_config_i     (uart_config)
  );

  // UART transmitter
  uart_tx tx_inst
  (
    .clk            (clk),
    .rst_n          (rst_resync),
    .tck            (tck),
    .tx_q_o         (tx_line),
    .tx_rts_n_o     (tx_rts_n),
    .tx_cts_n_i     (tx_cts_n),
    .tx_enable_i    (tx_enable),
    .tx_d_i         (tx_data),
    .tx_d_valid_i   (tx_data_valid),
    .tx_full_o      (txfifo_full),
    .tx_empty_o     (txfifo_empty),
    .tx_irq_flags_o (tx_irq_flags),
    .uart_config_i  (uart_config)
  ); 

  // UART Flow control
  uart_flow_ctrl uart_fc_inst
  (
    .tck           (tck),
    .rst_n         (rst_resync),
    .rts_n_o       (rts_n),
    .cts_n_i       (cts_n),
    .tx_rts_n_i    (tx_rts_n),
    .tx_cts_n_o    (tx_cts_n),
    .tx_enable_o   (tx_enable),
    .rx_rts_n_o    (rx_rts_n),
    .rx_cts_n_i    (rx_cts_n),
    .rx_enable_o   (rx_enable),
    .uart_config_i (uart_config)
  );

  // TCK generator
  always_ff @(posedge clk) begin
    if(counter >= (uart_divider/2)) begin
      tck <= !tck;
      counter <= 0;
    end else begin
      tck <= tck;
      counter <= counter + 1; 
    end
  end
  
  assign isfullduplex = uart_config.mode == FULLDUPLEX;

  // Data Control
  assign tx      = ((~isfullduplex & uart_config.master) | isfullduplex) ? tx_line : 1'b1;
  assign rx_line = (~(isfullduplex | uart_config.master) | isfullduplex) ? rx      : 1'b1;

  assign rx_irq = |(rx_irq_flags & uart_rxirqmask[$bits(RXIrqFlags_t)-1:0]);
  assign tx_irq = |(tx_irq_flags & uart_txirqmask[$bits(TXIrqFlags_t)-1:0]);

  // R/TX status
  // [parity not equal, master transmitter, fifo full, fifo empty]
  assign rx_status = {27'h0, frame_len_error, parity_error, 1'b0, rxfifo_full, rxfifo_empty};
  assign tx_status = {27'h0,            1'b0,         1'b0, 1'b1, txfifo_full, txfifo_empty};

endmodule
