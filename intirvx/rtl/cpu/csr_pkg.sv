

package csr_pkg;
import cpu_parameters::*;

  // Initials values
  localparam mhartid_i    = 'h0;
  localparam mstatus_i    = 'h0;
  localparam misa_i       = 'h40000100;
  localparam medeleg_i    = 'h0;
  localparam mideleg_i    = 'h0;
  localparam mie_i        = 'h0;
  localparam mtvec_i      = 'h0;
  localparam mcounteren_i = 'h0;
  localparam mscratch_i   = 'h0;
  localparam mepc_i       = 'h0;
  localparam mcause_i     = 'h0;
  localparam mtval_i      = 'h0;
  localparam mip_i        = 'h0;
  localparam mcycle_i     = 'h0;
  localparam minstret_i   = 'h0;
  localparam mtime_i      = 'h0;

  // MASKs and addresses
  localparam MHARTID = 12'hF14;
  localparam MHARTID_MSK = 32'hFFFFFFFF;

  localparam MSTATUS = 12'h300;
  localparam MSTATUS_MSK = 32'h7F801ECC;

  localparam MISA = 12'h301;
  localparam MISA_MSK = 32'h00000000;

  localparam MEDELEG = 12'h302;
  localparam MEDELEG_MSK = 32'hFFFFFFFF;

  localparam MIDELEG = 12'h303;
  localparam MIDELEG_MSK = 32'hFFFFFFFF;

  localparam MIE = 12'h304;
  localparam MIE_MSK = 32'h0000888;

  localparam MTVEC = 12'h305;
  localparam MTVEC_MSK = 32'hFFFFFFFF;

  localparam MCOUNTEREN = 12'h306;
  localparam MCOUNTEREN_MSK = 32'h00000007;

  localparam MSCRATCH = 12'h340;
  localparam MSCRATCH_MSK = 32'hFFFFFFFF;

  localparam MEPC = 12'h341;
  localparam MEPC_MSK = 32'hFFFFFFFF;

  localparam MCAUSE = 12'h342;
  localparam MCAUSE_MSK = 32'hFFFFFFFF;

  localparam MTVAL = 12'h343;
  localparam MTVAL_MSK = 32'hFFFFFFFF;

  localparam MIP = 12'h344;
  localparam MIP_MSK = 32'h0000888;

  localparam MCYCLE = 12'hB00;
  localparam MCYCLE_MSK = 32'hFFFFFFFF;

  localparam MCYCLEH = 12'hB80;
  localparam MCYCLEH_MSK = 32'hFFFFFFFF;
 
  localparam MINSTRET = 12'hB02;
  localparam MINSTRET_MSK = 32'hFFFFFFFF;

  localparam MINSTRETH = 12'hB82;
  localparam MINSTRETH_MSK = 32'hFFFFFFFF;

  localparam MTIME = 12'hC01;
  localparam MTIME_MSK = 32'hFFFFFFFF;

  localparam MTIMEH = 12'hC81;
  localparam MTIMEH_MSK = 32'hFFFFFFFF;

  function logic[xlen-1:0] write_csr
  (
    // Value saved on the csr register
    logic[xlen-1:0] csr, 

    // Modifiable bits of the csr register
    logic[xlen-1:0] mask, 

    // Data to apply on the csr register
    logic[xlen-1:0] rs1, 

    // Selection mask 1
    logic[xlen-1:0] clear_mask1, 

    // Selection mask 2
    logic[xlen-1:0] clear_mask2
  );  
    return ((((csr & clear_mask1) | rs1) & clear_mask2) | ((csr & ~rs1) & ~clear_mask2)) & mask;
  endfunction

endpackage