

module tb_fifo 
(
  input logic clk,
  input logic rst_n
);

  logic [9:0] enq_data0;
  logic       enq_valid0;
  logic       enq_ready0;
  logic [9:0] deq_data0;
  logic       deq_valid0;
  logic       deq_ready0;
  logic       flush0;
  logic       full0;
  logic       empty0;

  //logic       enq_data1;
  //logic       enq_valid1;
  //logic       enq_ready1;
  //logic       deq_data1;
  //logic       deq_valid1;
  //logic       deq_ready1;
  //logic       flush1;
  //logic       full1;
  //logic       empty1;

  logic [9:0]   value, value_n;

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

  //fifo #(.data_size(1), .buffer_size(5)) fifo_1_i
  //(
  //  .clk       (clk),
  //  .rst_n     (rst_n),
  //  .enq_data  (enq_data1),
  //  .enq_valid (enq_valid1),
  //  .enq_ready (enq_ready1),
  //  .deq_data  (deq_data1),
  //  .deq_valid (deq_valid1),
  //  .deq_ready (deq_ready1),
  //  .flush     (flush1),
  //  .full      (full1),
  //  .empty     (empty1)
  //);

  typedef enum bit[4:0] {
    IDLE  = 5'h0,
    TEST0 = 5'h1,
    RESP0 = 5'h2,
    TEST1 = 5'h3,
    RESP1 = 5'h4,
    RESP2 = 5'h5,
    GOOD  = 5'h13,
    ERROR = 5'h14
  } FTEST_t;

  FTEST_t f0state, f0state_n;
  //FTEST_t f1state, f1state_n;

  always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      f0state <= IDLE;
      value <= 0;
      //f1state <= IDLE;
    end else begin
      f0state <= f0state_n;
      value <= value_n;
      //f1state <= f1state_n;
    end
  end

  always_comb begin
    f0state_n = f0state;
    enq_data0 = 0;
    enq_valid0 = 0;
    deq_ready0 = 0;
    flush0 = 0;
    value_n = value;

    casez (f0state)
      IDLE : begin
        value_n = 1;
        f0state_n = TEST0;
      end
      TEST0 : begin
        enq_data0 = 10'b1;
        enq_valid0 = 1;
        f0state_n = RESP0;
      end
      RESP0 : begin
        deq_ready0 = 1;
        if(deq_data0 == 10'b1 &&
           deq_valid0 == 1'b1 &&
           enq_ready0 == 1'b1 &&
           full0 == 1'b0 &&
           empty0 == 1'b0) begin
          f0state_n = TEST1;  
        end else begin
          f0state_n = ERROR;
        end
      end
      TEST1 : begin
        enq_data0 = value;
        value_n = value + 1;
        enq_valid0 = 1;
        deq_ready0 = 0;

        if(value == 4) begin
          value_n = 1;
          f0state_n = RESP1;
        end else
          f0state_n = TEST1;
      end
      RESP1 : begin
        deq_ready0 = 1;
        if(deq_data0 == value &&
           deq_valid0 == 1'b1 &&
           enq_ready0 == 1'b0 &&
           full0 == 1'b1 &&
           empty0 == 1'b0) begin
          value_n = 2;
          f0state_n = RESP2;  
        end else begin
          f0state_n = ERROR;
        end
      end
      RESP2 : begin
        deq_ready0 = 1;
        if(deq_data0 == value &&
           deq_valid0 == 1'b1 &&
           enq_ready0 == 1'b1 &&
           full0 == 1'b0 &&
           empty0 == 1'b0) begin
          value_n = value + 1;
          if(value != 4)
            f0state_n = RESP2;  
          else
            f0state_n = GOOD;  
        end else begin
          f0state_n = ERROR;
        end
      end
      GOOD : begin
        $display("GOOD\n");  
        $finish(1);
        $stop(1);
      end
      ERROR : begin
        $display("ERROR\n");  
        $finish(1);
        $stop(1);
      end
      default: begin
        assert (1) else $fatal("Error state");
        $finish(1);
        $stop(1);
      end
    endcase

  end
  
endmodule
