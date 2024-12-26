

package uart_defs;

  // Uart memory map
  localparam DIVIDER_ADR       = 12'h000;
  localparam RXDATA_ADR        = 12'h004;
  localparam RXSTATUS_ADR      = 12'h008;
  localparam RXIRQMASK_ADR     = 12'h00C;
  localparam TXDATA_ADR        = 12'h010;
  localparam TXSTATUS_ADR      = 12'h014;
  localparam TXIRQMASK_ADR     = 12'h018;
  localparam UART_STATUS_ADR   = 12'h01C;
  localparam VERSION_ADR       = 12'h020;

  localparam UART_STATUS_W_MASK = 32'h0000_0003;
  localparam UART_RXMASK_W_MASK = 32'h0000_003F;
  localparam UART_TXMASK_W_MASK = 32'h0000_0007;

  localparam VERSION_MAJOR   = 16'h1;
  localparam VERSION_MINOR   = 8'h0;
  localparam VERSION_PATCHES = 8'h0;

  // Modes of communication
  typedef enum bit[1:0] 
  {
    SIMPLEX    = 2'b00,
    HALFDUPLEX = 2'b01,
    FULLDUPLEX = 2'b10
  } Mode_t;

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

  typedef struct packed {
    Mode_t mode;
    // If the Uart communication mode
    // is SIMPLEX take into account this bit
    logic master;
    // Enable or disable rts and cts management
    logic flow_control;
    logic flush_rx;
    logic flush_tx;
  } Config_t;
endpackage

