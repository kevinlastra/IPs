


module intirvx
import cpu_parameters::*;
import interfaces_pkg::*;
(
  // Global interface
  input logic clk,
  input logic rst_n,
  
  // system imem interface
  ibus fetch_bus,

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
  logic [xlen-1:0]      inst_f2d;
  logic [alen-1:0]      inst_pc_f2d;
  logic [0:0]           inst_status_f2d;
  logic                 inst_f2d_valid;
  logic                 inst_f2d_ready;

  // pc_gen
  decode_bus       decode_d2r;
  logic [24:0]     decode_inst_d2r;
  logic [xlen-1:0] decode_pc_d2r;
  logic            decode_d2r_valid;
  logic            decode_d2r_ready;

  // PC control 
  logic[xlen-1:0] target;
  logic           target_valid;
  logic           target_ready;

  logic           flush_ifetch;
  logic           flush;

  logic j_instr_rm;
  logic j_instr_alu;

  // Register manager
  logic data_valid_rm2c;

  decode_bus decode_rm2c;
  logic[xlen-1:0] rs1;
  logic[xlen-1:0] rs2;
  logic[4:0] rd;
  logic[xlen-1:0] immediate_o;
  logic[xlen-1:0] pc_rm2c;
  logic instret_v;
  logic regman_valid;
  logic regman_ready;

  // ALU
  logic [xlen-1:0] alu_result;
  logic [4:0]      alu_rd;
  
  logic            alu_jump;
  logic [xlen-1:0] alu_jump_addr;

  logic            alu2regman_ready;
  logic            alu2ifetch_ready;
  logic            alu_ready;
  logic            alu_valid;

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

  wb_bus     wb;
  logic      wb_valid;

  assign flush = 1'b0;

  // instruction fetch Unit
  intirvx_ifetch ifetch_i
  (
    .clk          (clk),
    .rst_n        (rst_n),
    .fetch_bus    (fetch_bus),
    .inst         (inst_f2d),
    .inst_pc      (inst_pc_f2d),
    .inst_status  (inst_status_f2d),
    .inst_valid   (inst_f2d_valid),
    .inst_ready   (inst_f2d_ready),
    .target       (target),
    .target_valid (target_valid),
    .target_ready (target_ready),
    .flush        (flush_ifetch | alu_jump)
  );

  intirvx_decode decode_i
  (
    .clk             (clk),
    .rst_n           (rst_n),
    // F2D
    .inst            (inst_f2d),
    .inst_pc         (inst_pc_f2d),
    .inst_status     (inst_status_f2d),
    .inst_valid      (inst_f2d_valid),
    .inst_ready      (inst_f2d_ready),
    // D2R
    .decode          (decode_d2r),
    .decode_inst     (decode_inst_d2r),
    .decode_pc       (decode_pc_d2r),
    .decode_valid    (decode_d2r_valid),
    .decode_ready    (decode_d2r_ready),
    // ALU2D
    .alu_jump        (alu_jump),
    .alu_jump_addr   (alu_jump_addr),
    .alu_valid       (alu_valid),
    .alu_ready       (alu2ifetch_ready),
    // D2F
    .pc              (target),
    .pc_valid        (target_valid),
    .pc_ready        (target_ready),
    .flush_ifetch    (flush_ifetch),
    // Control
    .flush           (alu_jump)
  );

  intirvx_register_manager register_manager_i
  (
    .clk            (clk),
    .rst_n          (rst_n),
    // D2R
    .decode         (decode_d2r),
    .decode_inst    (decode_inst_d2r),
    .decode_pc      (decode_pc_d2r),
    .decode_valid   (decode_d2r_valid),
    .decode_ready   (decode_d2r_ready),
    // R2X
    .regman_decode  (decode_rm2c),
    .regman_pc      (pc_rm2c),
    .regman_rs1     (rs1),
    .regman_rs2     (rs2),
    .regman_rd      (rd),
    .regman_imm     (immediate_o),
    .regman_instret (instret_v),
    .regman_valid   (regman_valid),
    .regman_ready   (regman_ready),
    // Flush
    .flush        (alu_jump),
    // Write back bus
    .wb           (wb),
    .wb_valid     (wb_valid)
  );

  assign regman_ready = alu2regman_ready;

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

  intirvx_alu alu
  (
    // Clock & rst_n
    .clk           (clk),
    .rst_n         (rst_n),
    // Register manager interface
    .regman_decode (decode_rm2c),
    .regman_pc     (pc_rm2c),
    .regman_rs1    (rs1),
    .regman_rs2    (rs2),
    .regman_rd     (rd),
    .regman_imm    (immediate_o),
    .regman_valid  (regman_valid),
    .regman_ready  (alu2regman_ready),
    // Alu result interface
    .alu_result    (alu_result),
    .alu_rd        (alu_rd),
    .alu_jump      (alu_jump),
    .alu_jump_addr (alu_jump_addr),
    .alu_valid     (alu_valid),
    .alu_ready     (alu_ready & alu2ifetch_ready),
    // Flow control
    .flush         (flush)
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
    .clk       (clk),
    .rst_n     (rst_n),
    // ALU interface
    .alu_res   (alu_result),
    .alu_rd    (alu_rd),
    .alu_valid (alu_valid),
    .alu_ready (alu_ready),
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
    .wb       (wb),
    .wb_valid (wb_valid)
  );

endmodule

