


module uart_tx
import uart_defs::*;
(
  // System reset and clock
  input       logic       clk,
  input       logic       rst_n,

  input       logic       tck,

  // UART interface
  output      logic       tx_q_o,
  output      logic       tx_rts_n_o,
  input       logic       tx_cts_n_i,
  input       logic       tx_enable_i,

  // TX FIFO input
  input       logic [7:0] tx_d_i,
  input       logic       tx_d_valid_i,

  // TX FIFO output
  output      logic       tx_full_o,
  output      logic       tx_empty_o,

  // Uart configuration reg
  input                   Config_t uart_config_i,
);

TXState_t    state, state_q;

logic [7:0]  deq_data;
logic        deq_valid;
logic        deq_ready;

// 1 Start | 8 Data bits | 1 Parity | 1 Stop bits
logic [10:0] frame, frame_q;
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
  .enq_ready (),
  // Dequeue
  .deq_clk   (tck),
  .deq_data  (deq_data),
  .deq_valid (deq_valid),
  .deq_ready (deq_ready),
  // Status
  .full      (tx_full_o),
  .empty     (tx_empty_o),
  .flush     (uart_config_i.flush_tx || (uart_config_i.mode == SIMPLEX && !uart_config_i.master))
);

always_comb begin
  even = 0;
  for(int i = 0; i < 8; i++) begin
    even = deq_data[i] ^ even;
  end
end

always_comb begin
  state       = state_q;
  frame       = frame_q;
  cnt         = cnt_q;
  frame_bit   = 1'b1;
  deq_ready   = 1'b0;
  tx_rts_n_o  = 1;

  case(state_q)
    TX_IDLE : begin
      if((uart_config_i.mode == FULLDUPLEX || tx_enable_i) && deq_valid) begin
        cnt = 1;
        tx_rts_n_o = 0;
        if(!tx_cts_n_i) begin
          frame_bit = 1'b0;
          frame = {1'b1, even, deq_data[7:0], 1'b0};
          state = TX_SHIFT;
        end
      end
    end
    TX_SHIFT : begin
      frame_bit = frame_q[0];
      frame = {1'b0, frame_q[10:1]};
      cnt = {cnt_q[9:0], 1'b0};
      deq_ready = 1;
      if(cnt[10]) begin
        state = TX_IDLE;
      end
    end
    default : begin
      state = TX_IDLE;
    end
  endcase
end

always_ff @(posedge tck or negedge rst_n) begin
  if(!rst_n) begin
    state_q <= TX_IDLE;
    cnt_q   <= 11'b0;
    tx_q_o  <= 1'b1;
    frame_q <= 11'b0;
  end else begin
    state_q <= state;
    cnt_q   <= cnt;
    tx_q_o  <= frame_bit;
    frame_q <= frame;
  end
end

endmodule

