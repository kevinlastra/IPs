// ============================================================
// Project      : UART IP
// Author       : Kevin Lastra
// Description  : UART (Universal Asynchronous Receiver/Transmitter) 
// 
// Revision     : 1.0.0
// 
// License      : MIT License
// ============================================================

module uart
import uart_defs::*;
#(
  parameter logic [31:0] REG_ADDR_MAP = 32'h0
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
  axi4.slave   bus,

  output logic wakeup,
  output logic rx_irq,
  output logic tx_irq
);

// Uart clock
logic        tck;

logic [31:0] counter;

// Reg interface
logic [31:0] uart_divider;
logic [31:0] uart_rxirqmask;
logic [31:0] uart_txirqmask;
Config_t     uart_config;

// RX interface
logic        rx_enable;

RXStatus_t   rx_status;

logic [8:0]  rx_data;
logic        rx_data_valid;
logic        rx_data_ready;

// TX interface
logic        tx_enable;

TXStatus_t   tx_status;

logic [8:0]  tx_data;
logic        tx_data_valid;

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

// UART control and status register
uart_csr #(.REG_ADDR_MAP(REG_ADDR_MAP)) csr_inst
(
  .clk             (clk),
  .rst_n           (rst_resync),
  .bus             (bus),
  .divider_q_o     (uart_divider),
  .rxirqmask_q_o   (uart_rxirqmask),
  .txirqmask_q_o   (uart_txirqmask),
  .uart_config_q_o (uart_config),
  .tx_enable_o     (tx_enable),
  .tx_d_o          (tx_data),
  .tx_d_valid_o    (tx_data_valid),
  .rx_enable_o     (rx_enable),
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
  .rx_enable_i       (rx_enable),
  .rx_i              (rx),
  .rts_n_o           (rts_n),
  .rx_d_o            (rx_data),
  .rx_d_valid_o      (rx_data_valid),
  .rx_d_ready_i      (rx_data_ready),
  .rx_status_o       (rx_status),
  .wakeup_o          (wakeup),
  .uart_config_i     (uart_config)
);

// UART transmitter
uart_tx tx_inst
(
  .clk               (clk),
  .rst_n             (rst_resync),
  .tck               (tck),
  .tx_enable_i       (tx_enable),
  .tx_q_o            (tx),
  .cts_n_i           (cts_n),
  .tx_d_i            (tx_data),
  .tx_d_valid_i      (tx_data_valid),
  .tx_status_o       (tx_status),
  .uart_config_i     (uart_config)
);

assign rx_irq = |(32'(rx_status) & uart_rxirqmask);
assign tx_irq = |(32'(tx_status) & uart_txirqmask);

endmodule
