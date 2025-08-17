

module intirvx_ifetch
import cpu_parameters::*;
import axi5_pkg::*;
(
	// Global interface
	input logic                  clk,
	input logic                  rst_n,
  input logic [ilen-1:0]       hart_id,

  // Memory interface
  axi5.master                  axi,

	// Pc_gen interface
	output logic [xlen-1:0]      inst,
  output logic [alen-1:0]      inst_pc,
  output logic                 inst_valid,
  input  logic                 inst_ready,

  // PC Control interface
  input  logic [xlen-1:0]      target,
  input  logic                 target_valid,
  output logic                 target_ready,

  // Flow control
  input  logic                 flush
);

  AXSize_t    size_t;
  logic [3:0] incr_t;
  
  assign size_t = S32;
  assign incr_t = 4;

  logic [alen-1:0] int_pc, n_int_pc;
  
  typedef enum logic[1:0] 
  {  
    IDLE   = 0,
    RBURST = 1,
    FLUSH  = 2
  } State_t;

  State_t state, n_state;

  logic [63:0] fifo_data;
  logic        fifo_valid;
  logic        fifo_ready;

  always_comb begin : axi5_interface
    // FSM default
    n_state  = state;
    n_int_pc = int_pc;

    // AXI Default
    axi.aw       = '0;
    axi.aw_valid = 1'b0;
    axi.w        = '0;
    axi.w_valid  = '0;
    axi.b_ready  = '0;

    axi.ar.addr  = target;
    axi.ar.size  = size_t;
    axi.ar.burst = INCR;
    axi.ar.prot  = 3'b000;
    axi.ar.id    = hart_id;
    axi.ar.len   = 7;

    // Handshake defaults
    axi.ar_valid = 1'b0;
    target_ready = 1'b0;

    // FSM
    unique case (state)
      IDLE : begin
        // Start AXI5 transaction
        if(target_valid & !flush) begin
          axi.ar_valid = 1'b1;
          if(axi.ar_ready) begin
            target_ready = 1'b1;
            n_int_pc = target;
            n_state = RBURST;
          end
        end
      end
      RBURST : begin
        // Send the burst data to the fifo
        // TODO: check ID and resp (exceptions)
        if(~flush) begin
          // Connect fifo to AXI
          fifo_data   = {axi.r.data, int_pc};
          fifo_valid  = axi.r_valid;
          axi.r_ready = fifo_ready;
          // Check handshake
          if(axi.r_valid & axi.r_ready) begin
            n_int_pc = int_pc + 32'(incr_t);
            n_state = axi.r.last ? IDLE : RBURST;
          end 
        end else begin
          n_state = FLUSH;
        end
      end
      FLUSH : begin
        // Flush all data incomming
        axi.r_ready = 1'b1;
        if(axi.r_valid & axi.r_ready & axi.r.last) begin
          n_state = IDLE;
        end
      end
    endcase
  end

  always_ff @( posedge clk or negedge rst_n ) begin : fsm_ff
    if(~rst_n) begin
      state  <= IDLE;
      int_pc <= 0;
    end else begin
      state  <= n_state;
      int_pc <= n_int_pc;
    end
  end
  //------------------------------------------
  // F2D
  //------------------------------------------

  logic full;
  logic empty;

  fifo #(.data_size(64), .buffer_size(1)) pipeline_f2d
  (
    .clk        (clk),
    .rst_n      (rst_n),
    .enq_data   (fifo_data),
    .enq_valid  (fifo_valid),
    .enq_ready  (fifo_ready),
    .deq_data   ({inst, inst_pc}),
    .deq_valid  (inst_valid),
    .deq_ready  (inst_ready),
    .flush      (flush),
    .full       (full),
    .empty      (empty)
  );

endmodule
