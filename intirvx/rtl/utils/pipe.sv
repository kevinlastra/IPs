

module pipe
#(
  parameter DATA_SIZE = 1,
  parameter DEPTH = 1
)
(
  // Global interface
  input logic clk,
  input logic rst_n,

  input logic pop,
  output logic full,

  input logic[DATA_SIZE-1:0] data_i,
  input logic valid_i,

  output logic[DATA_SIZE-1:0] data_o,
  output logic valid_o
);

  initial begin
    assert (DEPTH < 1) $display("Pipe DEPTH shall be greater or equal than 1");
  end

generate if(DEPTH == 1) begin

  logic[DATA_SIZE-1:0] data;
  logic valid;

  always @(*) begin
    data_o = data;
    valid_o = valid;
  end

  always @(*) begin
    full = valid & !pop;
  end

  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      data <= '0;
      valid <= 0;
    end else if(pop) begin
      data <= data_i;
      valid <= valid_i;
    end
  end
  
end if(DEPTH > 1) begin

//  data_i -> data[DEPTH-1] -> ...... -> data[0] -> data_o

  logic[DATA_SIZE-1:0] data[DEPTH-1:0];
  logic valid[DEPTH-1:0];

  logic empty;

  always @(*) begin
    data_o = data[0];
    valid_o = valid[0];
  end

  always @(*) begin
    full = valid[DEPTH-1];
    empty = !valid[0];
  end

  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      data = '{default: '0};
      valid = '{default: 0};
    end else begin
      // POP data
      if(!empty && pop) begin
        // shift data on the pipe
        for(int i = 0; i < DEPTH-1; i++) begin
          if(!valid[i] && valid[i+1]) begin
            data[i] = data[i+1];
            valid[i] = valid[i+1];
          end
        end
      end
      if(!full) begin
        logic done = 0;
        // write new data
        for(int i = 0; i < DEPTH-1; i++) begin
          if(!valid[i] && !done) begin
            data[i] = data_i;
            valid[i] = valid_i;
            done = 1;
          end
        end
      end
    end
  end

end endgenerate
  
endmodule