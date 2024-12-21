

module fifo
  #(
    parameter int data_size = 0,
    parameter int buffer_size = 0
  ) 
  (
    input logic clk,
    input logic rst_n,

    input  logic [data_size-1:0] enq_data,
    input  logic                 enq_valid,
    output logic                 enq_ready,

    output logic [data_size-1:0] deq_data,
    output logic                 deq_valid,
    input  logic                 deq_ready,

    input logic                 flush,
    output logic                full,
    output logic                empty
  );

if (buffer_size == 1) begin

  logic [data_size-1:0] data;
  logic valid;
  
  always_ff @(posedge clk) begin
    if(enq_valid) begin
      data <= enq_data;
      valid = 1;
    end else begin
      valid = 0;
    end
  end

  always_comb begin
    if(deq_ready)
      deq_data = data;
    enq_ready = !full;
    deq_valid = !empty;


    full <= valid && !flush;
    empty <= !valid && flush;
  end

end else if (buffer_size > 1) begin

  logic [data_size-1:0] data[buffer_size];
  logic [buffer_size-1:0] wr_ptr;
  logic [buffer_size-1:0] rd_ptr;

  always_ff @(posedge clk) begin
    if(enq_valid && !full) begin
      data[wr_ptr] <= enq_data;
    end
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      wr_ptr <= 1;
      rd_ptr <= 1;
    end else begin 
      if(enq_valid && !full) begin
        if(wr_ptr << 1 == 0)
          wr_ptr <= 1;
        else
          wr_ptr <= wr_ptr << 1;
      end

      if(deq_ready && !empty) begin
        if(rd_ptr << 1 == 0)
          rd_ptr <= 1;
        else
          rd_ptr <= rd_ptr << 1;
      end

      if(flush) begin
        rd_ptr <= 1;
        wr_ptr <= 1;
      end
    end
  end

  always_comb begin
    if(deq_ready)
      deq_data = data[rd_ptr];
    enq_ready = !full;
    deq_valid = !empty;

    if(wr_ptr << 1 == 0)
      full = 1 == rd_ptr && !flush;
    else
      full = wr_ptr << 1 == rd_ptr && !flush;
    empty = wr_ptr == rd_ptr && flush;
  end

end

endmodule