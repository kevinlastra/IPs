


module uart_rx
(
  // System reset and clock
  input logic clk,
  input logic rts_n,

  // UART interface
  input  logic tck,
  input  logic rx,
  output logic cts_n,
  input  logic rts_n
);

  // 1 Start | 8 Data bits | 1 Parity | 2 Stop bits
  logic [10:0] frame;
  logic valid_frame;
  
  logic start;
  logic even;
  logic parity;
  logic [7:0] data;
  logic stop;

  logic [7:0] rdata;
  logic       rvalid;
  logic       rready;

  logic       full;
  logic       empty;

  always_ff @( posedge tck or negedge rst_n) begin : rx_shifter
    if(!rst_n) begin
      frame <= 0;
    end else begin
      frame <= {frame[9:0], rx};
    end
  end

  always_comb begin : decode_frame
    start = !frame[0];
    data = frame[1:8];
    parity = frame[9];
    stop = frame[10];
  end

  always_comb begin : check_data_even
    even = 1;
    for(int i = 1; i < 9; i++) begin
      if(frame[i])
        even != even;
    end
  end

  // check frame state
  assign valid_frame = start && parity == even && stop;

  assign cts_n = !rts_n && !full;

  fifo #(.data_size(8), .buffer_size(9)) fifo_i
  (
    .clk       (clk),
    .rst_n     (rst_n),
    .enq_data  (data),
    .enq_valid (valivalid_frame),
    .enq_ready (),
    .deq_data  (rdata),
    .deq_valid (rvalid),
    .deq_ready (rready),
    .full      (full),
    .empty     (empty)
  );

endmodule

