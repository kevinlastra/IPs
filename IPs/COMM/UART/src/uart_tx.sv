


module uart_tx
(
  // System reset and clock
  input logic clk,
  input logic rts_n,

  // TX FIFO input
  input logic [7:0] tx_data,
  input logic       tx_data_valid,
  input logic       tx_data_ready,

  // UART interface
  input  logic tck,
  input  logic tx,
  output logic rts_n,
  input  logic cts_n,

  // TX FIFO output
  output logic txfifo_full,
  output logic txfifo_empty,
  output logic tx_irq
);

  // TX IRQ flags
  // 0 : FIFO empty
  // 1 : FIFO half empty
  // 3 : Data sent

  struct {
    logic fifo_empty;
    logic fifo_half_full;
    logic data_sent;
  } irq_flags_t;

  enum bit[1:0] {
    IDLE = 0,
    SHIFT = 1,
    PARITY = 2,
    STOP = 3
  } State_t;

  State_t state, state_n;

  logic [10:0] deq_data;
  logic        deq_valid;
  logic        deq_ready;
  // 1 Start | 8 Data bits | 1 Parity | 1 Stop bits
  logic [10:0] frame;
  logic        even;
  logic [3:0]  cnt;
  logic        frame_bit;
  
  fifo #(.data_size(8), .buffer_size(8)) fifo_i
  (
    .clk       (clk),
    .rst_n     (rst_n),
    .enq_data  (tx_data),
    .enq_valid (tx_data_valid),
    .enq_ready (tx_data_ready),
    .deq_data  (deq_data),
    .deq_valid (deq_valid),
    .deq_ready (deq_ready),
    .full      (tx_bus.full),
    .empty     (tx_bus.empty)
  );

  always_comb begin
    even = 0;
    for(int i = 0; i < 8; i++) begin
      if(deq_data[i])
        even = !even;
    end
  end

  always_comb begin
    frame_bit = 1'b1;
    rts_n = 1;
    casez(state)
      IDLE : begin
        rts_n = 0;
        if(deq_valid && !cts_n) begin
          cnt = 0;
          frame = {1'b1, even, deq_data[7:0], 1'b0};
          state_n = SHIFT;
        end
      end
      SHIFT : begin
        rts_n = 0;
        frame_bit = frame[0];
        frame = {1'b0, fram[10:1]};
        cnt = cnt + 1;
        deq_ready = 1;
        if(cnt == 11) begin
          state_n = PARITY;
        end
      end
      PARITY : begin
        state_n = STOP;
      end
      STOP : begin
        state_n = IDLE;
      end
    endcase
  end

  always_ff @(posedge tck or negedge rst_n) begin
    if(!rst_n) begin
      state <= IDLE;
    end else begin
      state <= state_n;
    end
    tx <= frame_bit;
  end

  // TODO
  assign tx_irq = 1'b0;

endmodule

