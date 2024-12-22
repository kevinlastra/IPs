


module uart_rx
  import uart_defs::*;
  (
  // System reset and clock
  input logic clk,
  input logic rst_n,

  // UART interface
  input  logic tck,
  input  logic rx,

  // RX FIFO output
  output logic [7:0] rxfifo_data,
  output logic       rxfifo_valid,
  input  logic       rxfifo_ready,
  output logic       rxfifo_full,
  output logic       rxfifo_empty,
  output logic       error_parity,

  // Wakeup system if uart receive a frame
  output logic       wakeup,
  
  output RXIrqFlags_t rx_irq_flags
);

  typedef enum bit[1:0] {
    IDLE = 0,
    SHIFT = 1,
    PARITY = 2,
    STOP = 3
  } State_t;

  State_t state, state_n;

  // 1 Start | 8 Data bits | 1 Parity | 1 Stop bits
  logic [7:0] frame_data, frame_data_n;
  logic       frame_valid;

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
        if(cnt == 8) begin
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

  fifo #(.data_size(8), .buffer_size(8)) fifo_i
  (
    .clk       (clk),
    .rst_n     (rst_n),
    .enq_data  (frame_data),
    .enq_valid (frame_valid),
    .enq_ready (),
    .deq_data  (rxfifo_data),
    .deq_valid (rxfifo_valid),
    .deq_ready (rxfifo_ready),
    .full      (rxfifo_full),
    .empty     (rxfifo_empty),
    .flush     (1'b0)
  );

endmodule

