

interface uart_defs;

  parameter DIVIDER_ADR       = 8'h00;
  parameter RXDATA_ADR        = 8'h04;
  parameter RXSTATUS_ADR      = 8'h08;
  parameter TXDATA_ADR        = 8'h0C;
  parameter TXSTATUS_ADR      = 8'h10;
  parameter IRQMASK_ADR       = 8'h14;
  parameter UART_STATUS_ADR   = 8'h18;
  parameter VERSION_ADR       = 8'h1C;

  parameter VERSION_MAJOR   = 16'h1;
  parameter VERSION_MINOR   = 8'h0;
  parameter VERSION_PATCHES = 8'h0;

  // Modes of communication
  parameter SIMPLEX    = 2'b00;
  parameter HALFDUPLEX = 2'b01;
  parameter FULLDUPLEX = 2'b10;

endinterface
