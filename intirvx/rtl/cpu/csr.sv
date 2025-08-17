

module csr
import cpu_parameters::*;
import csr_pkg::*;
import interfaces_pkg::*;
(
  // Global interface
  input logic clk,
  input logic rst_n,

  // Register manager interface
  output logic ok_o,

  input decode_bus decode,
  input logic[xlen-1:0] pc,

  input logic[xlen-1:0] rs1,
  input logic[11:0] csr_adr,
  input logic[4:0] rd_i,
  input logic instret_v,

  // Write back interface
  output logic result_v,
  output logic[xlen-1:0] result,
  output logic[4:0] rd_o,
  output logic csr_exception,

  // PC Control interface
  output logic[xlen-1:0] target,
  input logic flush,

  input logic ok_i
);
logic valid_instruction;

logic[xlen-1:0] clear_mask1, clear_mask2;

logic[xlen-1:0] csr_value;

logic[$bits(csr_value)+
      $bits(rd_i)+
      $bits(valid_instruction)+
      $bits(exception_target)+
      $bits(exception)-1:0] data_i, data_o;

logic csr_fault;
logic exception;
logic[xlen-1:0] exception_target;

/* verilator lint_off UNOPTFLAT */

// User Counters/Timers
logic[63:0] mtime_q, mtime_d;

// Machine information
logic[xlen-1:0] mhartid_q, mhartid_d;

// Machine trap setup
logic[xlen-1:0] mstatus_q, mstatus_d;
logic[xlen-1:0] misa_q, misa_d;
logic[xlen-1:0] medeleg_q, medeleg_d;
logic[xlen-1:0] mideleg_q, mideleg_d;
logic[xlen-1:0] mie_q, mie_d;
logic[xlen-1:0] mtvec_q, mtvec_d;
logic[xlen-1:0] mcounteren_q, mcounteren_d;

// Machine trap handling
logic[xlen-1:0] mscratch_q, mscratch_d;
logic[xlen-1:0] mepc_q, mepc_d;
logic[xlen-1:0] mcause_q, mcause_d;
logic[xlen-1:0] mtval_q, mtval_d;
logic[xlen-1:0] mip_q, mip_d;

// Machine Counter/Timers
logic[63:0] mcycle_q, mcycle_d;
logic[63:0] minstret_q, minstret_d;

/* verilator lint_on UNOPTFLAT */

always begin
  clear_mask1 = decode.sel[0] ? 32'hFFFFFFFF : 'h0;
  clear_mask2 = decode.sel[1] ? 'h0 : 32'hFFFFFFFF;
end

always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    mhartid_d <= mhartid_i;
    mstatus_d <= mstatus_i;
    misa_d <= misa_i;
    medeleg_d <= medeleg_i;
    mideleg_d <= mideleg_i;
    mie_d <= mie_i;
    mtvec_d <= mtvec_i;
    mcounteren_d <= mcounteren_i;
    mscratch_d <= mscratch_i;
    mepc_d <= mepc_i;
    mcause_d <= mcause_i;
    mtval_d <= mtval_i;
    mip_d <= mip_i;
    mcycle_d <= mcycle_i;
    minstret_d <= minstret_i;
    mtime_d <= mtime_i;
  end else begin
    mhartid_d <= mhartid_q;
    mstatus_d <= mstatus_q;
    misa_d <= misa_q;
    medeleg_d <= medeleg_q;
    mideleg_d <= mideleg_q;
    mie_d <= mie_q;
    mtvec_d <= mtvec_q;
    mcounteren_d <= mcounteren_q;
    mscratch_d <= mscratch_q;
    mepc_d <= mepc_q;
    mcause_d <= mcause_q;
    mtval_d <= mtval_q;
    mip_d <= mip_q;
    mcycle_d <= mcycle_q;
    minstret_d <= minstret_q;
    mtime_d <= mtime_q;
  end
end

// Write
always begin
  csr_fault = '0; 
  mhartid_q = mhartid_d;
  mstatus_q = mstatus_d;
  misa_q = misa_d;
  medeleg_q = medeleg_d;
  mideleg_q = mideleg_d;
  mie_q = mie_d;
  mtvec_q = mtvec_d;
  mcounteren_q = mcounteren_d;
  mscratch_q = mscratch_d;
  mepc_q = mepc_d;
  mcause_q = mcause_d;
  mtval_q = mtval_d;
  mip_q = mip_d;
  minstret_q = minstret_d;
  mtime_q = mtime_d;

  if(rst_n) begin
    mcycle_q = mcycle_d + 1;
    if(instret_v)
    minstret_q = minstret_d + 1;
  end

  if(valid_instruction) begin
    case (csr_adr)
      MHARTID :
        mhartid_q = write_csr(mhartid_d, MHARTID_MSK, rs1, clear_mask1, clear_mask2);
      MSTATUS :
        mstatus_q = write_csr(mstatus_d, MSTATUS_MSK, rs1, clear_mask1, clear_mask2);
      MISA :
        misa_q = write_csr(misa_d, MISA_MSK, rs1, clear_mask1, clear_mask2);
      MEDELEG :
        medeleg_q = write_csr(medeleg_d, MEDELEG_MSK, rs1, clear_mask1, clear_mask2);
      MIDELEG :
        mideleg_q = write_csr(mideleg_d, MIDELEG_MSK, rs1, clear_mask1, clear_mask2);
      MIE :
        mie_q = write_csr(mie_d, MIE_MSK, rs1, clear_mask1, clear_mask2);
      MTVEC :
        mtvec_q = write_csr(mtvec_d, MTVEC_MSK, rs1, clear_mask1, clear_mask2);
      MCOUNTEREN :
        mcounteren_q = write_csr(mcounteren_d, MCOUNTEREN_MSK, rs1, clear_mask1, clear_mask2);
      MSCRATCH :
        mscratch_q = write_csr(mscratch_d, MSCRATCH_MSK, rs1, clear_mask1, clear_mask2);
      MEPC :
        mepc_q = write_csr(mepc_d, MEPC_MSK, rs1, clear_mask1, clear_mask2);
      MCAUSE : 
        mcause_q = write_csr(mcause_d, MCAUSE_MSK, rs1, clear_mask1, clear_mask2);
      MTVAL :
        mtval_q = write_csr(mtval_d, MTVAL_MSK, rs1, clear_mask1, clear_mask2);
      MIP :
        mip_q = write_csr(mip_d, MIP_MSK, rs1, clear_mask1, clear_mask2);
      MCYCLE :
        mcycle_q[31:0] = write_csr(mcycle_q[31:0], MCYCLE_MSK, rs1, clear_mask1, clear_mask2);
      MCYCLEH :
        mcycle_q[63:32] = write_csr(mcycle_d[63:32], MCYCLEH_MSK, rs1, clear_mask1, clear_mask2);
      MINSTRET :
        minstret_q[31:0] = write_csr(minstret_d[31:0], MINSTRET_MSK, rs1, clear_mask1, clear_mask2);
      MINSTRETH : 
        minstret_q[63:32] = write_csr(minstret_d[63:32], MINSTRETH_MSK, rs1, clear_mask1, clear_mask2);
      MTIME :
        mtime_q[31:0] = write_csr(mtime_d[31:0], MTIME_MSK, rs1, clear_mask1, clear_mask2);
      MTIMEH :
        mtime_q[63:32] = write_csr(mtime_d[63:32], MTIMEH_MSK, rs1, clear_mask1, clear_mask2);
      default: 
        csr_fault = '1;
    endcase
  end
end

// Read
always begin
  if(valid_instruction) begin
    case (csr_adr)
      MHARTID :
        csr_value = mhartid_d;
      MSTATUS :
        csr_value = mstatus_d;
      MISA :
        csr_value = misa_d;
      MEDELEG :
        csr_value = medeleg_d;
      MIDELEG :
        csr_value = mideleg_d;
      MIE :
        csr_value = mie_d;
      MTVEC :
        csr_value = mtvec_d;
      MCOUNTEREN :
        csr_value = mcounteren_d;
      MSCRATCH :
        csr_value = mscratch_d;
      MEPC :
        csr_value = mepc_d;
      MCAUSE : 
        csr_value = mcause_d;
      MTVAL :
        csr_value = mtval_d;
      MIP :
        csr_value = mip_d;
      MCYCLE :
        csr_value = mcycle_d[31:0];
      MCYCLEH :
        csr_value = mcycle_d[63:32];
      MINSTRET :
        csr_value = minstret_d[31:0];
      MINSTRETH :
        csr_value = minstret_d[63:32];
      MTIME :
        csr_value = mtime_d[31:0];
      MTIMEH :
        csr_value = mtime_d[63:32];
      default: 
        csr_fault = '1;
    endcase
  end
end

always begin
  exception = csr_fault | decode.mret | decode.illegal_instr;  
end

always begin
  if(decode.mret)
    exception_target = mepc_d;
  // else
  // TODO: if interruption then exception_target = mtvec
end

always begin
  data_i = 
  {
    (exception ? 'h0 : csr_value),
    rd_i,
    valid_instruction,
    exception_target,
    exception
  };
end

fifo #(.DATA_SIZE($bits(data_i))) pipeline_csr2wb
(
  .clk(clk),
  .rst_n(rst_n),
  .data_i(data_i),
  .flush(flush),
  .ok(ok_i),
  .data_o(data_o)
);

always begin
  {
    result,
    rd_o,
    result_v,
    target,
    csr_exception
  } = data_o;
end

always begin
  ok_o = decode.unit == 2'h2;
  valid_instruction = decode.unit == 2'h2;
end

endmodule