


module basic_mem
//import system_config::*;
(
    // Global inputs
    input logic clk,
    input logic rst_n,

    // Request
    input logic r_v,
    input logic w_v,
    input logic[xlen-1:0] adr,
    input logic[xlen-1:0] data,
    input logic[3:0] strobe,

    // Answer
    output logic[xlen-1:0] resp,
    output logic ack
);
parameter xlen = 32;
parameter CELL_SIZE = 8;
parameter NB_CELLS = 200000;


logic [CELL_SIZE-1:0] mem[NB_CELLS-1:0];

always @(negedge clk) begin
  if(rst_n && w_v) begin
    if(strobe[0])
      mem[adr] <= data[7:0];
    if(strobe[1])
      mem[adr] <= data[15:8];
    if(strobe[2])
      mem[adr] <= data[23:16];
    if(strobe[3])
      mem[adr] <= data[31:24];
  end
end


always @(negedge clk) begin
  if(rst_n && r_v) begin
    resp <= {mem[adr+3], mem[adr+2], mem[adr+1], mem[adr]};
    ack <= 1;
  end
end

endmodule
