



module fifo 
#(parameter DATA_SIZE = 32)
(
  // Global interace
  input logic clk,
  input logic rst_n,

  // input
  input logic[DATA_SIZE-1:0] data_i,
  input logic flush,
  input logic ok,

  // output
  output logic[DATA_SIZE-1:0] data_o
);


// local variables
logic[DATA_SIZE-1:0] data;


always_ff @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    data_o <= '0;
  end else if(ok) begin
    data_o <= data;
  end
end

always  begin
  if(flush) begin
    data = 'h0;    // bubble
  end else begin
    data = data_i;
  end
end


endmodule
 