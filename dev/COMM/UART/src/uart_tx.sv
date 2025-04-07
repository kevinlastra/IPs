// ============================================================
// Project      : UART IP
// Author       : Kevin Lastra
// Description  : UART (Universal Asynchronous Receiver/Transmitter) 
// 
// Revision     : 1.0.0
// 
// License      : MIT License
// ============================================================

module uart_tx
  import uart_defs::*;
  (
  // System reset and clock
  input logic       clk,
  input logic       rst_n,
  
  input  logic      tck,

  input  logic      tx_enable_i,

  // UART interface
  output logic      tx_q_o,
  input  logic      cts_n_i,

  // TX FIFO
  input logic [7:0] tx_d_i,
  input logic       tx_d_valid_i,

  // Status
  output TXStatus_t tx_status_o,

  // Uart configuration reg
  input Config_t    uart_config_i
);

  TXState_t    state_q, state_d;

  logic        tx_d_ready;

  logic [7:0]  deq_data;
  logic        deq_valid;
  logic        deq_ready;

  logic        fifo_full;
  logic        fifo_empty;
  logic        overflow_error;

  // 1 Start | 8 Data bits | 1 Parity
  logic [9:0]  frame, frame_q;
  logic        even;
  logic [10:0] cnt_q, cnt;
  logic        frame_bit;
  
  fifo_async #(.data_size(8), .buffer_size(8)) fifo_i
  (
    .rst_n     (rst_n),
    // Enqueue
    .enq_clk   (clk),
    .enq_data  (tx_d_i),
    .enq_valid (tx_d_valid_i),
    .enq_ready (tx_d_ready),
    // Dequeue
    .deq_clk   (tck),
    .deq_data  (deq_data),
    .deq_valid (deq_valid),
    .deq_ready (deq_ready),
    // Status
    .full      (fifo_full),
    .empty     (fifo_empty),
    .flush     (uart_config_i.flush_tx)
  );

  always_comb begin
    even = 0;
    for(int i = 0; i < 8; i++) begin
      even = deq_data[i] ^ even;
    end
  end

  always_comb begin
    state_d = state_q;

    frame = frame_q;
    cnt = cnt_q;

    frame_bit = 1'b1;
    deq_ready = 1'b0;

    case(state_q)
      TX_IDLE : begin
        if(tx_enable_i & deq_valid) begin
          cnt = 1;
          if(!cts_n_i) begin
            frame_bit = 1'b0;
            frame = {1'b1, even, deq_data[7:0]};
            state_d = TX_SHIFT;
          end
        end
      end
      TX_SHIFT : begin
        frame_bit = frame_q[0];
        frame = {1'b0, frame_q[9:1]};
        cnt = {cnt_q[9:0], 1'b0};
        if(cnt[10]) begin
          deq_ready = 1;
          state_d = TX_IDLE;
        end
      end
      default : begin
        state_d = TX_IDLE;
      end
    endcase
  end

  always_ff @(posedge tck or negedge rst_n) begin
    if(!rst_n) begin
      state_q <= TX_IDLE;
      cnt_q <= 11'b0;
      tx_q_o <= 1'b1;
      frame_q <= 10'b0;
    end else begin
      state_q <= state_d;
      cnt_q <= cnt;
      tx_q_o <= frame_bit;
      frame_q <= frame;
    end
  end


  // TX Status
  always_ff @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
      overflow_error <= 0;
    end else begin
      overflow_error <= overflow_error | (tx_d_valid_i & ~tx_d_ready);
    end
  end

  assign tx_status_o = $size(TXStatus_t)'({overflow_error, fifo_full, fifo_empty});

endmodule

