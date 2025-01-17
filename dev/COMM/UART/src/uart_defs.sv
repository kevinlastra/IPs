

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
    logic fifo_empty;
    logic fifo_full;
  } TXIrqFlags_t;

  typedef struct packed {
    logic data_valid;
    logic fifo_empty;
    logic fifo_full;
    logic parity_error;
    logic framing_error;
    logic overrun_error;
  } RXIrqFlags_t;

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
    REG_IDLE    = 2'd0,
    REG_RRESP   = 2'd1,
    REG_BRESP   = 2'd2
  } REGState_t;

  typedef enum bit[1:0] {
    TX_IDLE   = 2'd0,
    TX_SHIFT  = 2'd1
  } TXState_t;

  typedef enum bit[1:0] {
    RX_IDLE   = 2'd0,
    RX_SHIFT  = 2'd1,
    RX_PARITY = 2'd2,
    RX_STOP   = 2'd3
  } RXState_t;

  typedef enum bit[1:0]
  {
    FC_IDLE   = 2'd0,
    FC_DIST   = 2'd1,
    FC_LOCAL  = 2'd2
  } FCState_t;

endpackage

