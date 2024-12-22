


module uart_tx
  import uart_defs::*;
  (
  // System reset and clock
  input logic clk,
  input logic rst_n,

  // UART interface
  input  logic tck,
  output logic tx,
  output logic rts_n,
  input  logic cts_n,

  // TX FIFO input
  input logic [7:0] txdata,
  input logic       txdata_valid,

  // TX FIFO output
  output logic txfifo_full,
  output logic txfifo_empty,

  output TXIrqFlags_t tx_irq_flags
);

  typedef enum bit[1:0] {
    IDLE = 0,
    SHIFT = 1,
    PARITY = 2,
    STOP = 3
  } State_t;

  State_t state, state_n;

  logic [7:0] deq_data;
  logic        deq_valid;
  logic        deq_ready;
  // 1 Start | 8 Data bits | 1 Parity | 1 Stop bits
  logic [10:0] frame, frame_n;
  logic        even;
  logic [3:0]  cnt, cnt_n;
  logic        frame_bit;
  
  fifo #(.data_size(8), .buffer_size(8)) fifo_i
  (
    .clk       (clk),
    .rst_n     (rst_n),
    .enq_data  (txdata),
    .enq_valid (txdata_valid),
    .enq_ready (),
    .deq_data  (deq_data),
    .deq_valid (deq_valid),
    .deq_ready (deq_ready),
    .full      (txfifo_full),
    .empty     (txfifo_empty),
    .flush     (1'b0)
  );

  always_comb begin
    even = 0;
    for(int i = 0; i < 8; i++) begin
      if(deq_data[i])
        even = !even;
    end
  end

  always_comb begin
    state_n = state;

    frame_n = frame;
    cnt_n = cnt;
    frame_bit = 1'b1;
    rts_n = 1;
    deq_ready = 1'b0;

    casez(state)
      IDLE : begin
        rts_n = 0;
        if(deq_valid && !cts_n) begin
          cnt_n = 0;
          frame_n = {1'b1, even, deq_data[7:0], 1'b0};
          state_n = SHIFT;
        end
      end
      SHIFT : begin
        rts_n = 0;
        frame_bit = frame[0];
        frame_n = {1'b0, frame[10:1]};
        cnt_n = cnt + 1;
        deq_ready = 1;
        if(cnt_n == 11) begin
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

endmodule

