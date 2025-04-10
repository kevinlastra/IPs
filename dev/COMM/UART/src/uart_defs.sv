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

  // Uart memory map {sel: 1b, adr: 12b}
  localparam DIVIDER       = {1'b1, 12'h000};
  localparam RXDATA        = {1'b1, 12'h004};
  localparam RXSTATUS      = {1'b1, 12'h008};
  localparam RXIRQMASK     = {1'b1, 12'h00C};
  localparam TXDATA        = {1'b1, 12'h010};
  localparam TXSTATUS      = {1'b1, 12'h014};
  localparam TXIRQMASK     = {1'b1, 12'h018};
  localparam STATUS        = {1'b1, 12'h01C};
  localparam VERSION       = {1'b1, 12'h020};

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
    // is SIMPLEX or HALFDUPLEX take this bit into account
    // 1 - Master     : use only TX line
    // 0 - Not master : use only RX line
    logic master;
    // Enable or disable rts and cts management
    logic flow_control;
    logic flush_rx;
    logic flush_tx;
  } Config_t;

  // States machines

  typedef enum bit[1:0] 
  { 
    REG_RST  = 0,
    REG_IDLE = 1,
    REG_RRESP = 2,
    REG_BRESP = 3
  } REGState_t;

  typedef enum bit[1:0] {
    TX_IDLE = 0,
    TX_SHIFT = 1
  } TXState_t;

  typedef enum bit[1:0] {
    RX_IDLE   = 0,
    RX_SHIFT  = 1,
    RX_PARITY = 2,
    RX_STOP   = 3
  } RXState_t;

  typedef enum bit[1:0] 
  {  
    FC_IDLE = 0,
    FC_DIST = 1,
    FC_LOCAL = 2
  } FCState_t;

endpackage

