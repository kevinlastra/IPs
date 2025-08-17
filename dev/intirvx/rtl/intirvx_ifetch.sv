

module intirvx_ifetch
import cpu_parameters::*;
(
	// Global interface
	input logic                  clk,
	input logic                  rst_n,

  // Memory interface
  ibus                         fetch_bus,

	// Pc_gen interface
	output logic [xlen-1:0]      inst,
  output logic [alen-1:0]      inst_pc,
  output logic [ibus_rlen-1:0] inst_status,
  output logic                 inst_valid,
  input  logic                 inst_ready,

  // PC Control interface
  input  logic [xlen-1:0]      target,
  input  logic                 target_valid,
  output logic                 target_ready,

  // Flow control
  input  logic                 flush
);

  logic [alen-1:0] inst_pc_int;

  //------------------------------------------
  // D2F
  //------------------------------------------

  always_comb begin
    fetch_bus.req.adr = target;
    if(!flush) begin
      fetch_bus.req_valid = target_valid;
      target_ready = fetch_bus.req_ready;
    end else begin
      fetch_bus.req_valid = 1'b0;
      target_ready = 1'b0;
    end
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      inst_pc_int <= '0;
    end else begin
      if(fetch_bus.req_valid & fetch_bus.req_ready) begin
        inst_pc_int <= target;
      end
    end
  end

  //------------------------------------------
  // F2D
  //------------------------------------------

  fifo #(.DATA_SIZE(65)) pipeline_f2d
  (
    .clk        (clk),
    .rst_n      (rst_n),
    .enq        ({fetch_bus.resp, inst_pc_int}),
    .enq_valid  (fetch_bus.resp_valid),
    .enq_ready  (fetch_bus.resp_ready),
    .deq        ({inst, inst_status, inst_pc}),
    .deq_valid  (inst_valid),
    .deq_ready  (inst_ready),
    .flush      (flush)
  );

endmodule
