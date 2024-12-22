

package uart_defs;

  // Uart memory map
  localparam DIVIDER_ADR       = 12'h000;
  localparam RXDATA_ADR        = 12'h004;
  localparam RXSTATUS_ADR      = 12'h008;
  localparam TXDATA_ADR        = 12'h00C;
  localparam TXSTATUS_ADR      = 12'h010;
  localparam RXIRQMASK_ADR     = 12'h014;
  localparam TXIRQMASK_ADR     = 12'h018;
  localparam UART_STATUS_ADR   = 12'h01C;
  localparam VERSION_ADR       = 12'h020;

  // Modes of communication
  localparam SIMPLEX    = 2'b00;
  localparam HALFDUPLEX = 2'b01;
  localparam FULLDUPLEX = 2'b10;

  localparam VERSION_MAJOR   = 16'h1;
  localparam VERSION_MINOR   = 8'h0;
  localparam VERSION_PATCHES = 8'h0;

  typedef struct packed {
    logic fifo_empty;
    logic fifo_half_full;
    logic data_sent;
  } TXIrqFlags_t;

  typedef struct packed {
    logic data_ready;
    logic fifo_half_full;
    logic fifo_full;
    logic parity_error;
    logic framing_error;
    logic overrun_error;
  } RXIrqFlags_t;

endpackage
