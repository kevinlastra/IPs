


module uart_rx
  import uart_defs::*;
  (
  // System reset and clock
  input logic clk,
  input logic rst_n,

  // UART interface
  input  logic tck,
  input  logic rx,
  input  logic rx_rts_n,
  output logic rx_cts_n,
  input  logic rx_enable,

  // RX FIFO output
  output logic [7:0] rxfifo_data,
  output logic       rxfifo_valid,
  input  logic       rxfifo_ready,
  output logic       rxfifo_full,
  output logic       rxfifo_empty,
  output logic       error_parity,

  // Wakeup system if uart receive a frame
  output logic       wakeup,
  
  // Irq flags
  output RXIrqFlags_t rx_irq_flags,

  // Uart configuration reg
  input Config_t uart_config
);

  localparam fifo_buffer_size = 8;

  typedef enum bit[1:0] {
    IDLE = 0,
    SHIFT = 1,
    PARITY = 2,
    STOP = 3
  } State_t;

  State_t state, state_n;

  logic [$clog2(fifo_buffer_size)-1:0] fifo_cnt;

  // 1 Start | 8 Data bits | 1 Parity | 1 Stop bits
  logic [7:0] frame_data, frame_data_n;
  logic       frame_valid;
  logic       frame_ready;

  logic even, even_n;

  logic [3:0] cnt, cnt_n;

  always_comb begin
    state_n = state;

    frame_data_n = frame_data;
    cnt_n = cnt;
    wakeup = 1'b0;
    frame_valid = 1'b0;
    error_parity = 1'b0;
    even_n = even;
    
    rx_cts_n = 1;

    if(uart_config.mode == FULLDUPLEX || rx_enable) begin
          
      // RX flow control
      rx_cts_n = !(!rx_rts_n & frame_ready); 

      casez(state)
        IDLE : begin
          if(!rx) begin
            wakeup = 1'b1;
            cnt_n = 0;
            even_n = 1'b1;
            frame_data_n = '0;
            state_n = SHIFT;
          end
        end
        SHIFT : begin
          frame_data_n = {rx, frame_data[7:1]};
          wakeup = 1'b1;
          cnt_n = cnt + 1;
          even_n = rx ? !even : even;
          if(cnt_n == 8) begin
            state_n = PARITY;
          end
        end
        PARITY : begin
          wakeup = 1'b1;
          error_parity = rx == even;
          frame_valid = 1'b1;
  
          state_n = STOP;
        end
        STOP : begin
          state_n = IDLE;
        end
      endcase
    end
  end

  always_ff @( posedge tck or negedge rst_n) begin
    if(!rst_n) begin
      state <= IDLE;
      frame_data <= '0;
      cnt <= '0;
      even <= 1'b0;
    end else begin
      state <= state_n;
      frame_data <= frame_data_n;
      cnt <= cnt_n;
      even <= even_n;
    end
  end

  fifo_async #(.data_size(8), .buffer_size(fifo_buffer_size)) fifo_i
  (
    .rst_n     (rst_n),
    .enq_clk   (tck),
    .enq_data  (frame_data),
    .enq_valid (frame_valid),
    .enq_ready (frame_ready),
    .deq_clk   (clk),
    .deq_data  (rxfifo_data),
    .deq_valid (rxfifo_valid),
    .deq_ready (rxfifo_ready),
    .full      (rxfifo_full),
    .empty     (rxfifo_empty),
    .flush     (uart_config.flush_rx)
  );

endmodule

