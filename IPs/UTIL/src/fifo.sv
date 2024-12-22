

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

if (buffer_size == 1) begin : single_buffer

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
    enq_ready = !full || full && deq_ready;
    deq_valid = !empty;

    full <= valid && !flush;
    empty <= !valid && flush;
  end

end else if (buffer_size > 1) begin : nsize_buffer

  logic [data_size-1:0] data[buffer_size];
  logic [buffer_size-1:0] wr_ptr;
  logic [buffer_size-1:0] rd_ptr;

  always_ff @(posedge clk) begin
    if(enq_valid && !full) begin
      for(int i = 0; i < buffer_size; i++) begin
        if(wr_ptr[i]) begin
          data[i] <= enq_data;
        end
      end
    end
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      wr_ptr <= 1;
      rd_ptr <= 1;
    end if(!flush) begin 
      if(enq_valid && !full) begin
        wr_ptr <= (wr_ptr << 1 == '0) ? (buffer_size)'(1) : wr_ptr << 1;
      end

      if(deq_ready && !empty) begin
        rd_ptr <= (rd_ptr << 1 == '0) ? (buffer_size)'(1) : rd_ptr << 1;
      end
    end if(flush) begin
      rd_ptr <= 1;
      wr_ptr <= 1;
    end
  end

  always_comb begin
    deq_data = '0;
    for(int i = 0; i < buffer_size; i++) begin
      if(rd_ptr[i]) begin
        deq_data = data[i];
      end
    end
    
    enq_ready = !full;
    deq_valid = !empty;
  end

  always_comb begin
    full = (wr_ptr << 1 == 0)? ('1 == rd_ptr) : (wr_ptr << 1 == rd_ptr);
    empty = (wr_ptr == rd_ptr);
  end

end else begin : error
  initial begin
    assert (1) else $fatal("The buffer size shall be greather or equal than 1");
  end
end

endmodule