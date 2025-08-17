


module intirvx_decode
import cpu_parameters::*;
import interfaces_pkg::*;
(
  // Global interface
  input logic             clk,
  input logic             rst_n,

  // Ifetch interface
  input  logic [xlen-1:0] inst,
  input  logic [alen-1:0] inst_pc,
  input  logic            inst_valid,
  output logic            inst_ready,

  // Register manager interface
  output decode_bus       decode,
  output logic [24:0]     decode_inst,
  output logic [alen-1:0] decode_pc,
  output logic            decode_valid,
  input  logic            decode_ready,

  // Alu interface
  input  logic             alu_jump,
  input  logic [xlen-1:0]  alu_jump_addr,
  input  logic             alu_valid,
  output logic             alu_ready,

  // PC control interface
  output logic[xlen-1:0]  pc,
  output logic            pc_valid,
  input  logic            pc_ready,
  output logic            flush_ifetch,

  // Decode control
  input logic             flush
  );

  // local variables
  logic            rst_n_q;

  decode_bus       decode_int;

  logic[18:0]      parsed_instr;
  logic[24:0]      reg_imm_parse_instr;

  logic[31:0]      jal_imm;

  logic [xlen-1:0] next_pc;
  logic            next_pc_ready;

  logic            full;
  logic            empty;

  //------------------------------------------
  // PC
  //------------------------------------------

  assign jal_imm = {{12{inst[31]}}, inst[19:12], inst[20], inst[30:21], 1'b0};

  always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      rst_n_q <= 0;
    end else begin
      rst_n_q <= rst_n;
    end
  end

  logic cal_pc_valid;
  logic next_pc_valid;

  // calc new address
  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      pc       <= '0;
      cal_pc_valid <= 0;
    end else begin
      cal_pc_valid <= next_pc_valid;
      if(!rst_n_q) begin
        pc     <= START_PC;
      end else if(next_pc_valid) begin
        pc     <= next_pc;
      end
    end
  end
  
  assign pc_valid = cal_pc_valid & !flush_ifetch;
  assign alu_ready = pc_ready;
  
  always_comb begin
    next_pc_valid = 1;
    if(alu_valid & alu_jump) begin
      next_pc = alu_jump_addr;
    end else if(decode_int.jal) begin
      next_pc = inst_pc + jal_imm;
    end else if(inst_ready) begin
      next_pc = pc + (alen == 32 ? 4 : 8);
    end else begin
      next_pc_valid = 0;
      next_pc = pc;
    end
  end

  //------------------------------------------
  // Decode
  //------------------------------------------

  assign parsed_instr  = {inst[31:25], inst[21:20], inst[14:12], inst[6:0]};
  assign reg_imm_parse_instr = inst[31:7];
  
  intirvx_decode_decoder decoder_i
  (
    .inst   (parsed_instr),
    .decode (decode_int)
  );

  assign flush_ifetch = decode_int.jal;

  //------------------------------------------
  // D2R
  //------------------------------------------

  pipe #(.DATA_SIZE(74), .DEPTH(4)) pipe_i
  (
    .clk       (clk),
    .rst_n     (rst_n),
    .enq_data  ({decode_int, reg_imm_parse_instr, inst_pc}),
    .enq_valid (inst_valid),
    .enq_ready (inst_ready),
    .deq_data  ({decode, decode_inst, decode_pc}),
    .deq_valid (decode_valid),
    .deq_ready (decode_ready),
    .full      (full),
    .empty     (empty)
  );

endmodule
