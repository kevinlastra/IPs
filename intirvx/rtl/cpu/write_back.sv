


module write_back
import cpu_parameters::*;
(
  // Global interface
  input logic clk,
  input logic rst_n,

  // ALU interface
  input logic[xlen-1:0] alu_res,
  input logic[4:0] alu_rd,
  input logic alu_res_v,

  output logic alu_ok,

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
  output logic[xlen-1:0] result,
  output logic[4:0] rd,
  output logic result_v
);


logic[2:0] res_v;

logic exception;

always begin
  res_v =  {alu_res_v && (alu_rd != 0), 
            csr_res_v && (csr_rd != 0),
            mem_res_v && (mem_rd != 0)};
end

always begin
  exception = csr_exception | mem_exception;
end

always begin
  result_v = 1;
  case (res_v)
    3'b001: begin
      result = mem_res;
      rd = mem_rd;
    end
    3'b010: begin
      result = csr_res;
      rd = csr_rd;
    end
    3'b100: begin
      result = alu_res;
      rd = alu_rd;
    end 
    default
      result_v = 0;
  endcase
end

always begin
  alu_ok = !exception;
  mem_ok = !exception;
  csr_ok = 1;
end


endmodule
