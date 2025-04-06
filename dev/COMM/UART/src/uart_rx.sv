


module uart_rx
import uart_defs::*;
(
  // System reset and clock
  input       logic       clk,
  input       logic       rst_n,

  input       logic       tck,

  // UART interface
  input       logic       rx_i,
  input       logic       rx_rts_n_i,
  output      logic       rx_cts_n_o,

  input       logic       rx_enable_i,

  // RX FIFO output
  output      logic [7:0] rx_d_o,
  output      logic       rx_d_valid_o,
  input       logic       rx_d_ready_i,

  output      logic       rx_full_o,
  output      logic       rx_empty_o,

  output      logic       parity_error_o,
  output      logic       frame_len_error_o,
  output      logic       overrun_error_o,

  // Wakeup system if uart receive a frame
  output      logic       wakeup_o,

  // Uart configuration reg
  input      Config_t    uart_config_i
);

localparam fifo_buffer_size = 8;

RXState_t state, state_q;

logic [$clog2(fifo_buffer_size)-1:0] fifo_cnt;

// 1 Start | 8 Data bits | 1 Parity | 1 Stop bits
logic [7:0] frame_data;
logic [7:0] frame_data_q;
logic       frame_valid;
logic       frame_ready;

logic       even_q;
logic       even;

logic [7:0] cnt;
logic [7:0] cnt_q;

// RX flow control
assign rx_cts_n_o = (uart_config_i.mode == FULLDUPLEX || rx_enable_i) & rx_rts_n_i & frame_ready;

always_comb begin
  state = state_q;

  frame_data = frame_data_q;
  cnt = cnt_q;
  wakeup_o = 1'b0;
  frame_valid = 1'b0;
  parity_error_o = 1'b0;
  frame_len_error_o = 1'b0;
  even = even_q;

  case(state_q)
    RX_IDLE : begin
      if((uart_config_i.mode == FULLDUPLEX || rx_enable_i) & ~rx_i) begin
        wakeup_o = 1'b1;
        cnt = 8'h1;
        even = 1'b1;
        frame_data = '0;
        state = RX_SHIFT;
      end
    end
    RX_SHIFT : begin
      frame_data = {rx_i, frame_data_q[7:1]};
      wakeup_o = 1'b1;
      cnt = {cnt_q[6:0], 1'b0};
      even = rx_i ^ even_q;
      if(cnt_q[7]) begin
        state = RX_PARITY;
      end
    end
    RX_PARITY : begin
      wakeup_o = 1'b1;
      parity_error_o = rx_i & even_q;  // sync parity_error to tck same for wakeup
      frame_valid = 1'b1;

      state = RX_STOP;
    end
    RX_STOP : begin
      frame_len_error_o = ~rx_i;
      state = RX_IDLE;
    end
  endcase
end

always_ff @( posedge tck or negedge rst_n) begin
  if(!rst_n) begin
    state_q <= RX_IDLE;
    frame_data_q <= '0;
    cnt_q <= '0;
    even_q <= 1'b0;
  end else begin
    state_q <= state;
    frame_data_q <= frame_data;
    cnt_q <= cnt;
    even_q <= even;
  end
end

fifo_async #(.data_size(8), .buffer_size(fifo_buffer_size)) fifo_i
(
  .rst_n     (rst_n),
  // Enqueue
  .enq_clk   (tck),
  .enq_data  (frame_data_q),
  .enq_valid (frame_valid),
  .enq_ready (frame_ready),
  // Dequeue
  .deq_clk   (clk),
  .deq_data  (rx_d_o),
  .deq_valid (rx_d_valid_o),
  .deq_ready (rx_d_ready_i),
  // Status
  .full      (rx_full_o),
  .empty     (rx_empty_o),
  .flush     (uart_config_i.flush_rx)
);

assign overrun_error_o = rx_full_o & frame_valid;

endmodule

