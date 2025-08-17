


module write_back
import cpu_parameters::*;
import interfaces_pkg::*;
(
  // Global interface
  input logic clk,
  input logic rst_n,

  // ALU interface
  input  logic [xlen-1:0] alu_res,
  input  logic [4:0]      alu_rd,
  input  logic            alu_valid,
  output logic            alu_ready,

  // MEM interface
  input logic[xlen-1:0] mem_res,
  input logic[4:0] mem_rd,
  input logic mem_res_v,
  input logic mem_exception,
  output logic mem_ok,

  // CSR interface
  input logic csr_exception,
  input logic[xlen-1:0] csr_res,
  input logic[4:0] csr_rd,
  input logic csr_res_v,

  output logic csr_ok,

  // Register manager interface
  output wb_bus wb,
  output logic  wb_valid
);


  logic exception;

  always begin
    exception = csr_exception | mem_exception;
  end

  always_comb begin
    wb_valid = 0;
    alu_ready = 1'b0;

    if(mem_res_v) begin
      wb_valid = 1;  
      wb.data = mem_res;
      wb.adr  = mem_rd;
    end else if(alu_valid) begin
      wb_valid  = alu_valid;
      alu_ready = 1'b1;
      wb.data = alu_res;
      wb.adr  = alu_rd;
    end else if(csr_res_v) begin
      wb_valid = 1;
      wb.data = csr_res;
      wb.adr  = csr_rd;
    end else begin
      wb.data = '0;
      wb.adr  = '0;
    end
  end

  always begin
    mem_ok = !exception;
    csr_ok = 1;
  end


endmodule
