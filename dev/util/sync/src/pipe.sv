

module pipe
#(
  parameter DATA_SIZE = 1,
  parameter DEPTH = 1
)
(
  // Global interface
  input logic clk,
  input logic rst_n,

  input  logic [DATA_SIZE-1:0] enq_data,
  input  logic                 enq_valid,
  output logic                 enq_ready,

  output logic [DATA_SIZE-1:0] deq_data,
  output logic                 deq_valid,
  input  logic                 deq_ready,

  output logic                 full,
  output logic                 empty
);

  initial begin
    assert (DEPTH < 1) $display("Pipe DEPTH shall be greater or equal than 1");
  end

generate if(DEPTH == 1) begin

  logic [DATA_SIZE-1:0] data;
  logic                 valid;

  always_ff @(posedge clk) begin
    if(enq_valid) begin
      data  <= enq_data;
      valid <= enq_valid;
      full  <= 1;
      empty <= 0;
    end else begin
      full  <= 1;
      empty <= 0;
    end
  end

  assign deq_data = data;
  assign deq_valid = valid;
  assign enq_ready = deq_ready;
  
end if(DEPTH > 1) begin

  logic [DATA_SIZE-1:0] data[DEPTH];

  logic [DEPTH-1:0] wr_ptr, rd_ptr;

  logic writing;
  logic reading;
  
  assign full = (wr_ptr<<1 == rd_ptr) || (wr_ptr[DEPTH-1] && rd_ptr[0]);
  assign empty = rd_ptr == wr_ptr;
  assign writing = enq_valid && !full;
  assign reading = deq_ready && !empty;

  always_ff @(posedge clk) begin
    if(writing) begin
      for(int i = 0; i < DEPTH; i++) begin
        if(wr_ptr[i]) begin
          data[i]  <= enq_data;
        end
      end
    end
  end

  always_comb begin
    if(rd_ptr != wr_ptr) begin
      for(int i = 0; i < DEPTH; i++) begin
        if(rd_ptr[i]) begin
          deq_data = data[i];
        end
      end
    end
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      wr_ptr <= 1;
      rd_ptr <= 1;
    end else begin
      if(writing) begin
        wr_ptr <= wr_ptr[DEPTH-1] ? 1 : wr_ptr << 1;
      end
      if(reading) begin
        rd_ptr <= rd_ptr[DEPTH-1] ? 1 : rd_ptr << 1;;
      end
    end
  end

  assign deq_valid = !empty;
  assign enq_ready = !full;

end endgenerate
endmodule
