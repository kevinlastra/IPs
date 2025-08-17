



module ifetch
import cpu_parameters::*;
(
	// Global interface
	input logic clk,
	input logic rst_n,

  // Memory interface
  output logic[xlen-1:0] target_address,
  input logic[xlen-1:0] resp,
  input logic resp_v,

	// Pc_gen interface
	output logic[xlen-1:0] instruction,
  output logic instruction_v,
  input logic ok,

  // PC Control interface
  input logic[xlen-1:0] target,
  input logic flush
);

logic[$bits(resp)+$bits(resp_v)-1:0] data_i, data_o;


always begin
  target_address = target;
end

always begin
  data_i = {resp, resp_v};
end

fifo #(.DATA_SIZE($bits(data_i))) pipeline_f2d
(
  .clk(clk),
  .rst_n(rst_n),
  .data_i(data_i),
  .flush(!ok),
  .ok(ok),
  .data_o(data_o)
);

always begin
  {instruction, instruction_v} = data_o;
end



endmodule
