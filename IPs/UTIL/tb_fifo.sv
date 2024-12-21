

module tb_fifo


  logic clk;
  logic rst_n;

  logic [9:0] enq_data0;
  logic       enq_valid0;
  logic       enq_ready0;
  logic [9:0] deq_data0;
  logic       deq_valid0;
  logic       deq_ready0;
  logic       flush0;
  logic       full0;
  logic       empty0;

  logic [9:0] enq_data1;
  logic       enq_valid1;
  logic       enq_ready1;
  logic [9:0] deq_data1;
  logic       deq_valid1;
  logic       deq_ready1;
  logic       flush1;
  logic       full1;
  logic       empty1;

  fifo #(.data_size(10), .buffer_size(5)) fifo_0_i
  (
    .clk       (clk),
    .rst_n     (rst_n),
    .enq_data  (enq_data0),
    .enq_valid (enq_valid0),
    .enq_ready (enq_ready0),
    .deq_data  (deq_data0),
    .deq_valid (deq_valid0),
    .deq_ready (deq_ready0),
    .flush     (flush0),
    .full      (full0),
    .empty     (empty0)
  );

  fifo #(.data_size(1), .buffer_size(5)) fifo_1_i
  (
    .clk       (clk),
    .rst_n     (rst_n),
    .enq_data  (enq_data1),
    .enq_valid (enq_valid1),
    .enq_ready (enq_ready1),
    .deq_data  (deq_data1),
    .deq_valid (deq_valid1),
    .deq_ready (deq_ready1),
    .flush     (flush1),
    .full      (full1),
    .empty     (empty1)
  );

  always_comb begin
    clk = 1;
    #5
    clk = 0;
    #5
  end

  initial begin
    rst_n = 1;
    #20
    rst_n = 0;

    // fifo 0
    // single read and write same cycle
    enq_data0 = 10'h1;
    enq_valid0 = 1;
    deq_ready0 = 1;

    #5
    enq_valid0 = 0;
    #5
    // single read and write next cycle
    enq_data0 = 10'h2;
    enq_valid0 = 1;

    #5
    deq_ready0 = 1;
    #5
    enq_valid0 = 0;
    #5
    // multiple write and read
    enq_data0 = 10'h3;
    enq_valid0 = 1;
    #5
    enq_data0 = 10'h4;
    enq_valid0 = 1;
    #5
    enq_data0 = 10'h5;
    enq_valid0 = 1;
    #5

    #5
    enq_valid0 = 0;
    deq_ready0 = 1;
    #5
    deq_ready0 = 1;
    #5
    deq_ready0 = 1;
    #5
    deq_ready0 = 1;
    #5
    // flush
    flush0 = 1;
    #5

    // full
    // empty

    // fifo 1
    
    // single read and write

    // multiple write and read

    // flush

    // full
    // empty
  end
endmodule