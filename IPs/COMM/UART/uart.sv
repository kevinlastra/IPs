

// UART interface
// 0: Receive
// 1: Transmitte
// 2: Ready to send
// 3: Clear to send

module 
  #(
    parameter map = 0x0;
  ) 
    uart
  (
    // System reset and clock
    input logic rst_n,
    input logic clk,
    
    // Bus
    axi4 bus,

    // UART interface
    input  logic rx,
    output logic tx,
    input  logic rts_n,
    output logic cts_n
  );

  logic [31:0] version_r;
  logic [31:0] error, error_r;

  enum bit[1:0]
  {
    IDLE = 0,
    XX
  } State_t;

  State_t state, state_n;

  uart_reg #(.map(map)) uart_reg_i
  (
    .rst_n (rst_n),
    .clk   (clk),
    .bus   (bus)
  );

  uart_rx uart_i 
  (
    .rst_n (rst_n),
    .clk   (clk),
    .rx    (rx),
    .cts_n (cts_n)
  );

  always_comb begin : State_machine
    error = 0;
    casex (state)
      IDLE : begin
        
      end 
      default:
        error = 1; 
    endcase
  end

  always_ff @( posedge tck or negedge rst_n) begin : clock_process
    if(!rst_n) begin
      state <= IDLE;
    end else begin
      reg_error <= error;
      state <= state_n;
    end
  end

endmodule