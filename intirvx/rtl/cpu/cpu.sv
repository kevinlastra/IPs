


module cpu
import cpu_parameters::*;
import interfaces_pkg::*;
(
  // Global interface
  input logic clk,
  input logic rst_n,
  input logic[xlen-1:0] start_address,
  
  // system imem interface
  input logic [xlen-1:0] resp_instruction,
  input logic resp_instruction_v,
  output logic [xlen-1:0] adr_instruction,

  // system dmem interface
  output logic r_v,
  output logic w_v,
  output logic[xlen-1:0] data_adr,
  output logic[xlen-1:0] data_o,
  output logic[3:0] strobe,

  input logic[xlen-1:0] dmem_res,
  input logic dmem_res_v,
  input logic dmem_res_error
); 

  // ifetch
  logic[xlen-1:0] instruction_f2d;
  logic instruction_f2d_v;

  // pc_gen
  logic ok_d2f;

  decode_bus decode_pg2r;

  logic[24:0] instruction_pg2r;
  logic[xlen-1:0] instr_pc;  
  logic[xlen-1:0] jal_res_i;
  logic[xlen-1:0] jal_res_o;

  // PC control 
  logic[xlen-1:0] target;
  logic[xlen-1:0] pg_target;
  logic pg_target_valide;

  logic jal_instr_pcc;

  logic flush;

  logic j_instr_rm;
  logic j_instr_alu;

  logic[xlen-1:0] pc_correction;

  // Register manager
  logic data_valid_rm2c;

  decode_bus decode_rm2c;
  logic[xlen-1:0] rs1;
  logic[xlen-1:0] rs2;
  logic[4:0] rd;
  logic[xlen-1:0] immediate_o;
  logic[xlen-1:0] pc_rm2c;
  logic ok_r2p;
  logic instret_v;

  // ALU
  logic alu_result_v;
  logic[xlen-1:0] alu_result;
  logic alu_target_v;
  logic[xlen-1:0] alu_target;
  logic[4:0] alu_rd;

  logic ok_alu2r;

  // MEM
  logic mem_result_v;
  logic[xlen-1:0] mem_result;

  logic[4:0] mem_rd;

  logic mem_exception;
  logic ok_mem2r;

  // CSR

  logic csr_result_v;
  logic[xlen-1:0] csr_result;
  logic[4:0] csr_rd;
  logic csr_exception;
  logic[xlen-1:0] csr_target;

  logic ok_csr2r;

  // Write back
  logic ok_wb2alu;
  logic ok_wb2mem;
  logic ok_wb2csr;

  logic[xlen-1:0] wb_res;
  logic wb_res_v;
  logic[4:0] wb_rd;

  // instruction fetch Unit
  ifetch ifetch
  (
    .clk(clk),
    .rst_n(rst_n),
    .target_address(adr_instruction),
    .resp(resp_instruction),
    .resp_v(resp_instruction_v),
    .instruction(instruction_f2d),
    .instruction_v(instruction_f2d_v),
    .ok(ok_d2f),
    .target(target),
    .flush(flush)
  );

  pc_gen pc_gen
  (
    .clk(clk),
    .rst_n(rst_n),
    .start_address(start_address),
    .instruction(instruction_f2d),
    .instruction_v(instruction_f2d_v),
    .ok_o(ok_d2f),
    .decode_o(decode_pg2r),
    .instruction_o(instruction_pg2r),
    .pc_o(instr_pc),
    .ok_i(ok_r2p),
    .next_pc_valide(pg_target_valide),
    .next_pc(pg_target),
    .jal_instr(jal_instr_pcc),
    .jal_res(jal_res_i),
    .flush(flush),
    .pc_correction(pc_correction)
  );

  pc_control pc_control
  (
    .clk(clk),
    .rst_n(rst_n),
    .target(target),
    .pg_target_valide(pg_target_valide),
    .pg_target(pg_target),
    .jal(jal_instr_pcc),
    .pc_correction(pc_correction),
    .alu_target_valide(alu_target_v),
    .alu_target(alu_target),
    .csr_target_valide(csr_exception),
    .csr_target(csr_target),
    .flush(flush)
  );

  register_manager register_manager
  (
    .clk(clk),
    .rst_n(rst_n),
    .ok_o(ok_r2p),
    .decode(decode_pg2r),
    .instruction(instruction_pg2r),
    .pc_i(instr_pc),
    .jal_res_i(jal_res_i),
    .decode_o(decode_rm2c),
    .pc_o(pc_rm2c),
    .rs1_o(rs1),
    .rs2_o(rs2),
    .rd_o(rd),
    .immediate_o(immediate_o),
    .jal_res_o(jal_res_o),
    .instret_v(instret_v),
    .flush(flush),
    .ok_i(ok_alu2r || ok_mem2r || ok_csr2r),
    .res_data(wb_res),
    .res_adr(wb_rd),
    .res_v(wb_res_v)
  );

  logic[$bits(decode_rm2c.unit)-1:0] unit;
  logic[$bits(decode_rm2c.sub_unit)-1:0] sub_unit;
  logic[$bits(decode_rm2c.sel)-1:0] sel;
  logic imm;
  always begin
    unit = decode_rm2c.unit;
    sub_unit = decode_rm2c.sub_unit;
    sel = decode_rm2c.sel;
    imm = decode_rm2c.imm;
  end

  alu alu
  (
    .clk(clk),
    .rst_n(rst_n),
    .ok_o(ok_alu2r),
    .unit(unit),
    .sub_unit(sub_unit),
    .sel(sel),
    .rs1(rs1),
    .rs2(rs2),
    .rd_i(rd),
    .pc(pc_rm2c),
    .immediate(immediate_o),
    .imm(imm),
    .result_valid(alu_result_v),
    .result(alu_result),
    .rd_o(alu_rd),
    .ok_i(ok_wb2alu),
    .target(alu_target),
    .target_valid(alu_target_v),
    .flush(flush)
  );

  mem mem
  (
    .clk(clk),
    .rst_n(rst_n),
    .ok_o(ok_mem2r),
    .unit(decode_rm2c.unit),
    .sub_unit(decode_rm2c.sub_unit),
    .sel(decode_rm2c.sel),
    .rs1(rs1),
    .rs2(rs2),
    .rd_i(rd),
    .immediate(immediate_o),
    .imm(decode_rm2c.imm),
    .r_v(r_v),
    .w_v(w_v),
    .req_adr(data_adr),
    .req_data(data_o),
    .req_strobe(strobe),
    .hit(dmem_res_v),
    .mem_res(dmem_res),
    .mem_res_error(dmem_res_error),
    .result(mem_result),
    .rd_o(mem_rd),
    .result_v(mem_result_v),
    .exception(mem_exception),
    .ok_i(ok_wb2mem)
  );

  csr csr
  (
    .clk(clk),
    .rst_n(rst_n),
    .ok_o(ok_csr2r),
    .decode(decode_rm2c),
    .pc(pc_rm2c),
    .rs1(rs1),
    .csr_adr(immediate_o[11:0]),
    .rd_i(rd),
    .instret_v(instret_v),
    .result_v(csr_result_v),
    .result(csr_result),
    .rd_o(csr_rd),
    .csr_exception(csr_exception),
    .target(csr_target),
    .flush(flush),
    .ok_i(ok_wb2csr)
  );

  write_back write_back
  (
    .clk(clk),
    .rst_n(rst_n),
    .alu_res(alu_result),
    .alu_rd(alu_rd),
    .alu_res_v(alu_result_v),
    .alu_ok(ok_wb2alu),
    .mem_res(mem_result),
    .mem_rd(mem_rd),
    .mem_res_v(mem_result_v),
    .mem_exception(mem_exception),
    .mem_ok(ok_wb2mem),
    .csr_exception(csr_exception),
    .csr_res(csr_result),
    .csr_rd(csr_rd),
    .csr_res_v(csr_result_v),
    .csr_ok(ok_wb2csr),
    .result(wb_res),
    .rd(wb_rd),
    .result_v(wb_res_v)
  );

endmodule
