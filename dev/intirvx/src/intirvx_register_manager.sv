



module intirvx_register_manager
import cpu_parameters::*;
import interfaces_pkg::*;
(
  // Global interface
  input logic clk,
  input logic rst_n,

  // decode interface
  input  decode_bus       decode,
  input  logic [24:0]     decode_inst,
  input  logic [xlen-1:0] decode_pc,
  input  logic            decode_valid,
  output logic            decode_ready,
  
  // Calculations units interface
  output decode_bus       regman_decode,
  output logic[xlen-1:0]  regman_pc,
  output logic[xlen-1:0]  regman_rs1,
  output logic[xlen-1:0]  regman_rs2,
  output logic[4:0]       regman_rd,
  output logic[xlen-1:0]  regman_imm,
  output logic            regman_instret,
  output logic            regman_valid,
  input  logic            regman_ready,

  // Flow control
  input logic             flush,

  // Answer from the calculation units
  input wb_bus            wb,
  input logic             wb_valid
);

  logic            enq_valid;
  logic            enq_ready;
  logic            deq_valid;

  logic [4:0]      rs1_adr;
  logic            rs1_adr_valid;
  logic [xlen-1:0] rs1;
  logic            rs1_valid;

  logic [4:0]      rs2_adr;
  logic            rs2_adr_valid;
  logic [xlen-1:0] rs2;
  logic            rs2_valid;

  logic[4:0]      rd;
  logic           rd_valid;

  logic[xlen-1:0]   immediate;

  logic[11:0]       s_imm;
  logic             s_imm_v;
  logic[19:0]       l_imm;
  logic             l_imm_v;

  logic             branch_instr;
  logic             branch_instr_o;

  logic             wb_valid_o;

  always_comb begin
    rd = decode_inst[4:0];
    rs1_adr = decode_inst[12:8];
    rs2_adr = decode_inst[17:13];

    if((decode.unit == 2'h0 && decode.sub_unit == 3'h1) || (decode.unit == 2'h1 && decode.sub_unit == 3'h1))
      s_imm = {decode_inst[24:18], decode_inst[4:0]};
    else
      s_imm = {decode_inst[24:13]};

    l_imm = decode_inst[24:5];
  end

  always_comb begin
    l_imm_v = 0;
    s_imm_v = 0;

    if(decode.unit == 2'h0 && decode.sub_unit == 3'h0 && decode.sel != 4'h3) begin
      l_imm_v = 1;
    end else if(decode.imm | (decode.unit == 2'h2)) begin
      s_imm_v = 1;
    end

    // if ALU sub 0 and not jarl then the rs1 is not used
    rs1_adr_valid = !l_imm_v;

    // if ALU and not immediate or SX
    rs2_adr_valid = (decode.unit == 2'h0 && decode.sub_unit != 3'h0 && (!decode.imm | decode.sub_unit == 3'h1)) | (decode.unit == 2'h1 && decode.sub_unit == 3'h1);

    branch_instr = (decode.unit == 2'h0 && decode.sub_unit == 3'h1) || 
                   (decode.unit == 2'h0 && decode.sub_unit == 3'h0 && decode.sel == 4'h3);

    // if not branch conditional or store decode_inst
    rd_valid = !(decode.unit == 2'h0 && decode.sub_unit == 3'h1) && !(decode.unit == 2'h1 && decode.sub_unit == 3'h1);
  end

  always_comb begin
    immediate = '0;
    
    if(l_imm_v) begin
      if(decode.unit == 2'h0 && decode.sub_unit == 3'h0 && decode.sel == 4'h2) // jal
        immediate = {{12{l_imm[19]}}, l_imm[10:1], l_imm[11], l_imm[19:12], 1'b0};
      else
        immediate = {l_imm, 12'h0};    
    end else if(s_imm_v) begin
      if(decode.unit == 2'h0 && decode.sub_unit == 3'h1) // b
          immediate = {{20{s_imm[11]}}, s_imm[0], s_imm[10:5], s_imm[4:1], 1'b0};
      else
        immediate =  {{20{s_imm[11]}} , s_imm};
    end
  end

  intirvx_register_file register_file
  (
    .clk           (clk),
    .rst_n         (rst_n),
    .w_adr         (wb.adr),
    .w_data        (wb.data),
    .w_valid       (wb_valid),
    .r0_adr        (rs1_adr),
    .r0_adr_valid  (rs1_adr_valid),
    .r0_data       (rs1),
    .r0_data_valid (rs1_valid),
    .r1_adr        (rs2_adr),
    .r1_adr_valid  (rs2_adr_valid),
    .r1_data       (rs2),
    .r1_data_valid (rs2_valid),
    .rd_adr        (rd),
    .rd_valid      (rd_valid),
    .flush         (flush)
  );

  // Flow control
  always_comb begin
    decode_ready = 0;
    enq_valid = 0;
    if(decode_valid & enq_ready
       & (rs1_adr_valid ? rs1_valid : 1'b1) 
       & (rs2_adr_valid ? rs2_valid : 1'b1)) begin
      decode_ready = 1; 
      enq_valid = 1;
    end
  end

  logic full;
  logic empty;

  fifo #(.data_size(152), .buffer_size(1)) pipeline_pg2r
  (
    .clk       (clk),
    .rst_n     (rst_n),
    .enq_data  ({decode, decode_pc, rs1, rs2, rd, immediate, wb_valid, branch_instr | decode.mret}),
    .enq_valid (enq_valid),
    .enq_ready (enq_ready),
    .deq_data  ({regman_decode, regman_pc, regman_rs1, regman_rs2, regman_rd, regman_imm, regman_instret, branch_instr_o}),
    .deq_valid (regman_valid),
    .deq_ready (regman_ready),
    .flush     (flush | branch_instr_o),
    .full      (full),
    .empty     (empty)
  );

endmodule
