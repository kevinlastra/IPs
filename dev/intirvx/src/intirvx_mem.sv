// ============================================================
// IP           : intirvx_mem
// Author       : Kevin Lastra
// Description  : IntiRVX CPU mem stage
// 
// Revision     : 1.0.0
// 
// License      : MIT License
// ============================================================

module intirvx_mem
	import cpu_parameters::*;
	import interfaces_pkg::*;
	import axi5_pkg::*;
	(
		// Global interface
		input logic 					 clk,
		input logic 					 rst_n,
		input logic [ilen-1:0] hart_id,

		// Register manager interface
		input  decode_bus			  regman_decode,
		input  logic [xlen-1:0] regman_rs1,
		input  logic [xlen-1:0] regman_rs2,
		input  logic [4:0]      regman_rd,
		input  logic [xlen-1:0] regman_imm,
		input  logic            regman_valid,
		output logic            regman_ready,

		// Mememory interface 
		axi5.master	axi,

		// Write back interface
		output logic [xlen-1:0] mem_res,
		output logic 						mem_exception,
		output logic [4:0] 			mem_rd,
		output logic 						mem_valid,
		input  logic						mem_ready
	);

	logic [31:0] 		 req_adr;
	logic [3:0]  		 req_strobe;
	logic				 		 req_read, p_req_read;
	logic				 		 req_write, p_req_write;
	logic [4:0]	 		 p_rd;

	logic [xlen-1:0] enq_data;
	logic 			 		 enq_resp;
	logic 			 		 enq_valid;
  logic 			 		 enq_ready;
	logic 					 full;
  logic 					 empty;

	assign req_adr   = regman_rs1 + regman_imm;
	assign req_read  = regman_decode.unit == 2'h1 && regman_decode.sub_unit == 3'h0;
	assign req_write = regman_decode.unit == 2'h1 && regman_decode.sub_unit == 3'h1;
	
	always begin
		if(regman_decode.sel == 4'h0) begin
			casez (req_adr)
				32'h???????0: req_strobe = 4'b0001;
				32'h???????1: req_strobe = 4'b0010;
				32'h???????2: req_strobe = 4'b0100;
				32'h???????3: req_strobe = 4'b1000; 
			endcase
		end else if(regman_decode.sel == 4'h1) begin
			casez (req_adr)
				32'h???????0: req_strobe = 4'b0011;
				32'h???????1: req_strobe = 4'b0110;
				32'h???????2: req_strobe = 4'b1100; 
			endcase
		end else begin
			req_strobe = 4'b1111;
		end
	end

	always_comb begin : send_axi
		// AW
		axi.aw.addr  = req_adr;
		axi.aw.size  = S32;
		axi.aw.burst = INCR;
		axi.aw.prot  = 3'b100;
		axi.aw.id 	 = hart_id;
		axi.aw.len 	 = 8'b0;
		axi.aw_valid = req_write;
		// W
		axi.w.last   = 1'b1;
		axi.w.data   = regman_rs2;
		axi.w.strb   = req_strobe;
		axi.w_valid  = req_write;
		// AR
		axi.aw.addr  = req_adr;
		axi.aw.size  = S32;
		axi.aw.burst = INCR;
		axi.aw.prot  = 3'b100;
		axi.aw.id 	 = hart_id;
		axi.aw.len 	 = 8'b0;
		axi.aw_valid = req_read;
	end

	assign regman_ready = (axi.aw_valid & axi.aw_ready) | (axi.ar_valid & axi.ar_ready);

	always_ff @( posedge clk or negedge rst_n ) begin : req_ff
		if(~rst_n) begin
			p_req_read  <= 1'b0;
			p_req_write <= 1'b0;
			p_rd				<= 5'h0;
		end else begin
			p_req_read  <= req_read;
			p_req_write <= req_write;
			p_rd				<= regman_rd;
		end
	end

	always_comb begin : receive_axi
		if(req_read & axi.r_valid) begin
			enq_data  = axi.r.data;
			enq_resp  = axi.r.resp != 0;
			enq_valid = 1'b1;
		end else if(req_write & axi.b_valid) begin
			enq_data  = '0;
			enq_resp  = axi.b.resp != 0;
			enq_valid = 1'b1;
		end else begin
			enq_data  = '0;
			enq_resp  = '0;
			enq_valid = 1'b0;
		end
	end

	assign axi.r_ready = enq_ready;

	fifo #(.data_size(38), .buffer_size(1)) pipeline_m2w
	(
	  .clk       (clk),
	  .rst_n     (rst_n),
	  .enq_data  ({enq_data, enq_resp, p_rd}),
	  .enq_valid (enq_valid),
	  .enq_ready (enq_ready),
	  .deq_data  ({mem_res, mem_exception, mem_rd}),
	  .deq_valid (mem_valid),
	  .deq_ready (mem_ready),
	  .flush     (1'b0),
    .full      (full),
    .empty     (empty)
	);

endmodule
