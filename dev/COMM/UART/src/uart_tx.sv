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
  input logic [8:0] tx_d_i,
  input logic       tx_d_valid_i,

  // Status
  output TXStatus_t tx_status_o,

  // Uart configuration reg
  input Config_t    uart_config_i
);

  FState_t state_q, state_d;

  logic        tx_d_ready;

  logic [8:0]  deq_data;
  logic        deq_valid;
  logic        deq_ready;

  logic        fifo_full;
  logic        fifo_empty;

  logic [8:0]  frame, frame_q;
  logic        even;
  logic        frame_bit;
  
  fifo_async #(.data_size(9), .buffer_size(8)) fifo_i
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
    for(int i = 0; i < 9; i++) begin
      even = deq_data[i] ^ even;
    end
  end

  always_comb begin
    state_d = state_q;

    frame = frame_q;

    frame_bit = 1'b1;
    deq_ready = 1'b0;

    case(state_q)
      IDLE : begin
        if(tx_enable_i & deq_valid) begin
          if((!cts_n_i & uart_config_i.flow_control) | !uart_config_i.flow_control) begin
            frame_bit = 1'b0;
            frame = deq_data;
            state_d = D1;
          end
        end
      end
      D1, D2, D3, D4  : begin
        frame_bit = frame_q[0];
        frame = {1'b0, frame_q[8:1]};
        if(state_d == D1) begin
          state_d = D2;
        end else if(state_d == D2) begin
          state_d = D3;
        end else if(state_d == D3) begin
          state_d = D4;
        end else if(state_d == D4) begin
          state_d = D5;
        end
      end
      D5 : begin
        frame_bit = frame_q[0];
        frame = {1'b0, frame_q[8:1]};
        if(uart_config_i.frame_len[0]) begin
          state_d = uart_config_i.parity ? PARITY : STOP;
        end else begin
          state_d = D6;
        end
      end
      D6 : begin
        frame_bit = frame_q[0];
        frame = {1'b0, frame_q[8:1]};
        if(uart_config_i.frame_len[1]) begin
          state_d = uart_config_i.parity ? PARITY : STOP;
        end else begin
          state_d = D7;
        end
      end
      D7 : begin
        frame_bit = frame_q[0];
        frame = {1'b0, frame_q[8:1]};
        if(uart_config_i.frame_len[2]) begin
          state_d = uart_config_i.parity ? PARITY : STOP;
        end else begin
          state_d = D8;
        end
      end
      D8 : begin
        frame_bit = frame_q[0];
        frame = {1'b0, frame_q[8:1]};
        if(uart_config_i.frame_len[3]) begin
          state_d = uart_config_i.parity ? PARITY : STOP;
        end else begin
          state_d = D9;
        end
      end
      D9 : begin
        frame_bit = frame_q[0];
        frame = {1'b0, frame_q[8:1]};
        state_d = uart_config_i.parity ? PARITY : STOP;
      end
      PARITY : begin
        frame_bit = even;
        state_d = STOP;
      end
      STOP : begin
        frame_bit = 1'b1;
        deq_ready = 1'b1;
        state_d = uart_config_i.dstop ? DSTOP : IDLE;
      end
      DSTOP : begin
        frame_bit = 1'b1;
        state_d = IDLE;
      end
      default : begin
        state_d = IDLE;
      end
    endcase
  end

  always_ff @(posedge tck or negedge rst_n) begin
    if(!rst_n) begin
      state_q <= IDLE;
      tx_q_o <= 1'b1;
      frame_q <= 9'b0;
    end else begin
      state_q <= state_d;
      tx_q_o <= frame_bit;
      frame_q <= frame;
    end
  end


  // TX Status
  always_ff @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
      tx_status_o <= 0;
    end else begin
      tx_status_o.fifo_full <= fifo_full;
      tx_status_o.fifo_empty <= fifo_empty;
      tx_status_o.overflow_error <= tx_status_o.overflow_error | (tx_d_valid_i & ~tx_d_ready);
    end
  end

endmodule

