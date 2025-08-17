

module pc_control
import cpu_parameters::*;
(
  // Global interface
  input logic clk,
  input logic rst_n,

  // ifetch iterface
  output logic[xlen-1:0] target,

  // pc_gen interface
  input logic pg_target_valide,
  input logic[xlen-1:0] pg_target,
  input logic jal,

  output logic[xlen-1:0] pc_correction, 

  // ALU interface
  input logic alu_target_valide,
  input logic[xlen-1:0] alu_target,

  // CSR interface
  input logic csr_target_valide,
  input logic[xlen-1:0] csr_target,

  output logic flush
);


always begin
  flush = 0;
  pc_correction = 'h0;

  if(csr_target_valide) begin
    target = csr_target;
    pc_correction = csr_target;
    flush = 1;
  end else if(alu_target_valide) begin
    target = alu_target;
    pc_correction = alu_target;
    flush = 1;
  end else if (pg_target_valide) begin
    target = pg_target;
  end
end


endmodule
