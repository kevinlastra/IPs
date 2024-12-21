


module uart_tx
(
  // System reset and clock
  input logic clk,
  input logic rts_n,

  // UART interface
  input  logic tck,
  output logic tx,

  // RX FIFO output
  output logic [7:0] rxfifo_data,
  output logic       rxfifo_valid,
  input  logic       rxfifo_ready,
  output logic       rxfifo_full,
  output logic       rxfifo_empty,
  output logic       error_parity,

  // Wakeup system if uart receive a frame
  output logic       wakeup,
  
  output logic       rx_irq
);
  // RX IRQ flags
  // 0 : Data ready
  // 1 : FIFO half full
  // 2 : FIFO full
  // 3 : Parity error
  // 4 : Framing error (stop bit missing)
  // 5 : Overrun error (Data lost caused by full)

  struct {
    logic data_ready;
    logic fifo_half_full;
    logic fifo_full;
    logic parity_error;
    logic framing_error;
    logic overrun_error;
  } irq_flags_t;

  irq_flags_t irq_flags;

  enum bit[1:0] {
    IDLE = 0,
    SHIFT = 1,
    PARITY = 2,
    STOP = 3
  } State_t;

  State_t state, state_n;

  // 1 Start | 8 Data bits | 1 Parity | 1 Stop bits
  logic [7:0] frame_data;
  logic       frame_valid;

  logic even;

  logic [3:0] cnt;

  always_comb begin
    wakeup = 1'b0;
    frame_valid = 0;
    
    casez(state)
      IDLE : begin
        if(!rx) begin
          wakeup = 1'b1;
          cnt = 0;
          even = 1'b1;
          frame_data = '0;
          state_n = SHIFT;
        end
      end
      SHIFT : begin
        frame_data = {rx, frame_data[7:0]};
        wakeup = 1'b1;
        cnt = cnt + 1;
        even = rx ? !even : even;
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
    end else begin
      state <= state_n;
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
    .empty     (rxfifo_empty)
  );

  // TODO
  assign rx_irq = 1'b0;

endmodule

