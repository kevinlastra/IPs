// ============================================================
// Project      : UART IP
// Author       : Kevin Lastra
// Description  : UART (Universal Asynchronous Receiver/Transmitter) 
// 
// Revision     : 1.0.0
// 
// License      : MIT License
// ============================================================

package uart_defs;

  // Uart memory map
  localparam DIVIDER       = 12'h000;
  localparam RXDATA        = 12'h004;
  localparam RXSTATUS      = 12'h008;
  localparam RXIRQMASK     = 12'h00C;
  localparam TXDATA        = 12'h010;
  localparam TXSTATUS      = 12'h014;
  localparam TXIRQMASK     = 12'h018;
  localparam CONTROL       = 12'h01C;
  localparam VERSION       = 12'h020;

  // Current version
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
    logic overflow_error;
    logic fifo_empty;
    logic fifo_full;
  } TXStatus_t;

  typedef struct packed {
    logic framing_error;
    logic parity_error;
    logic overrun_error;
    logic fifo_full;
    logic fifo_empty;
  } RXStatus_t;

  typedef struct packed {
    Mode_t mode;
    // If the Uart communication mode
    // is SIMPLEX take this bit into account
    // 1 - Master     : use only TX line
    // 0 - Not master : use only RX line
    logic master;
    // Frame length can be 5 to 9 bits (Default 5)
    logic [4:0] frame_len;
    // Enable or disable parity bit
    logic parity;
    // Enable or disable double stop bit
    logic dstop;
    // Enable or disable rts and cts management
    logic flow_control;
    // Flush RX FIFO
    logic flush_rx;
    // Flush TX FIFO
    logic flush_tx;
  } Config_t;

  // States machines

  typedef enum bit[2:0] 
  { 
    CSR_RST   = 0,
    CSR_IDLE  = 1,
    CSR_WAW   = 2,
    CSR_WW    = 3,
    CSR_RRESP = 4,
    CSR_BRESP = 5
  } REGState_t;

  typedef enum bit[3:0] {
    IDLE = 0,
    D1 = 1,
    D2 = 2,
    D3 = 3,
    D4 = 4,
    D5 = 5,
    D6 = 6,
    D7 = 7,
    D8 = 8,
    D9 = 9,
    PARITY = 10,
    STOP = 11,
    DSTOP = 12
  } FState_t;

endpackage

