// ============================================================
// Project      : UART IP
// Author       : Kevin Lastra
// Description  : UART (Universal Asynchronous Receiver/Transmitter) 
// 
// Revision     : 1.0.0
// 
// License      : MIT License
// ============================================================

module uart_rx
import uart_defs::*;
(
  // System reset and clock
  input       logic        clk,
  input       logic        rst_n,

  input       logic        tck,
  
  // UART interface
  input       logic        rx_i,
  output      logic        rts_n_o,

  // RX FIFO output
  output      logic [8:0]  rx_d_o,
  output      logic        rx_d_valid_o,
  input       logic        rx_d_ready_i,

  // Status
  output      RXStatus_t   rx_status_o,

  // Wakeup system if uart receive a frame
  output      logic        wakeup_o,

  // Uart configuration reg
  input       Config_t     uart_config_i
);

localparam fifo_buffer_size = 8;

FState_t state_d, state_q;

logic [$clog2(fifo_buffer_size)-1:0] fifo_cnt;

// 1 Start | 9 Data bits | 1 Parity | 2 Stop bits
logic [8:0] frame_data_d;
logic [8:0] frame_data_q;
logic       frame_valid;
logic       frame_ready;

logic       even_d;
logic       even_q;

logic       rx_q;

// FIFO
logic fifo_empty;
logic fifo_full;

// Errors
logic frame_len_error;
logic parity_error;
logic overrun_error;

assign wakeup_o = state_q != IDLE;

// RX frame
always_comb begin
  state_d = state_q;

  frame_data_d = frame_data_q;
  frame_valid = 1'b0;

  parity_error = 1'b0;
  frame_len_error = 1'b0;

  even_d = even_q;

  case(state_q)
    IDLE : begin
      if(uart_config_i.en_rx & ~rx_q) begin
        even_d = 1'b1;
        frame_data_d = '0;
        state_d = D1;
      end
    end
    D1, D2, D3, D4 : begin
      frame_data_d = {rx_q, frame_data_q[8:1]};
      even_d = rx_q ^ even_q;
      if(state_q == D1) begin
        state_d = D2;
      end else if(state_q == D2) begin
        state_d = D3;
      end else if(state_q == D3) begin
        state_d = D4;
      end else if(state_q == D4) begin
        state_d = D5;
      end
    end
    D5 : begin
      frame_data_d = {rx_q, frame_data_q[8:1]};
      even_d = rx_q ^ even_q;
      if(uart_config_i.frame_len[0]) begin
        frame_data_d = {4'h0, frame_data_d[8:4]};
        state_d = uart_config_i.parity ? PARITY : STOP;
      end else begin
        state_d = D6;
      end
    end
    D6 : begin
      frame_data_d = {rx_q, frame_data_q[8:1]};
      even_d = rx_q ^ even_q;
      if(uart_config_i.frame_len[1]) begin
        frame_data_d = {3'h0, frame_data_d[8:3]};
        state_d = uart_config_i.parity ? PARITY : STOP;
      end else begin
        state_d = D7;
      end
    end
    D7 : begin
      frame_data_d = {rx_q, frame_data_q[8:1]};
      even_d = rx_q ^ even_q;
      if(uart_config_i.frame_len[2]) begin
        frame_data_d = {2'h0, frame_data_d[8:2]};
        state_d = uart_config_i.parity ? PARITY : STOP;
      end else begin
        state_d = D8;
      end
    end
    D8 : begin
      frame_data_d = {rx_q, frame_data_q[8:1]};
      even_d = rx_q ^ even_q;
      if(uart_config_i.frame_len[3]) begin
        state_d = uart_config_i.parity ? PARITY : STOP;
        frame_data_d = {1'h0, frame_data_d[8:1]};
      end else begin
        state_d = D9;
      end
    end
    D9 : begin
      frame_data_d = {rx_q, frame_data_q[8:1]};
      even_d = rx_q ^ even_q;
      state_d = uart_config_i.parity ? PARITY : STOP;
    end
    PARITY : begin
      parity_error = rx_q != even_q;  // sync parity_error to tck same for wakeup
      state_d = STOP;
    end
    STOP : begin
      frame_valid = 1'b1;
      frame_len_error = ~rx_q;
      state_d = uart_config_i.dstop ? DSTOP : IDLE;
    end
    DSTOP : begin
      frame_len_error = ~rx_q;
      state_d = IDLE;
    end
    default : begin
      state_d = IDLE;
    end
  endcase
end

assign rts_n_o = ~(frame_ready & uart_config_i.en_rx);

always_ff @(posedge tck or negedge rst_n) begin
  if(!rst_n) begin
    frame_data_q <= 9'h0;
    state_q      <= IDLE;
    even_q       <= 1'b0;
    rx_q         <= 1'b1;
  end else begin
    frame_data_q <= frame_data_d;
    state_q      <= state_d;
    even_q       <= even_d;
    rx_q         <= rx_i;
  end
end

fifo_async #(.data_size(9), .buffer_size(fifo_buffer_size)) fifo_i
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
  .full      (fifo_full),
  .empty     (fifo_empty),
  .flush     (uart_config_i.flush_rx)
);

assign overrun_error = fifo_full & frame_valid;

assign rx_status_o = $size(RXStatus_t)'({frame_len_error, parity_error, overrun_error, fifo_full, fifo_empty});

endmodule

