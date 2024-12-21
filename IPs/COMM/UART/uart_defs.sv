

interface uart_defs;

  enum bit[1:0]
  {
    IDLE = 0,
    DATA8 = 1,
    PARITY = 2
  } RXState_t;

  RXState_t state, state_n;

endinterface