


module register_file
import cpu_parameters::*;
(
  // Global interface
  input logic clk,
  input logic rst_n,

  // Inputs
  input logic w_valid,
  input logic[4:0] w_ad,
  input logic[xlen-1:0] w_data,

  input logic r0_valid,
  input logic[4:0] r0_ad,

  input logic r1_valid,
  input logic[4:0] r1_ad,

  input logic block_rd,
  input logic[4:0] rd,

  input logic flush,

  // Outputs
  output logic[xlen-1:0] r0_data,
  output logic[xlen-1:0] r1_data,
  output logic r_v
);

logic[xlen-1:0] register[31:0];

// dispatch
logic reg_v_n[31:0];

always_latch begin
  r_v = 1;

  if(r0_valid) begin
    r0_data = register[r0_ad];
    r_v = !reg_v_n[r0_ad];
  end 
  if(r1_valid) begin
    r1_data = register[r1_ad];
    r_v = r_v & !reg_v_n[r1_ad];
  end
end

always @(posedge clk) begin
  if(w_valid) begin
    if(w_ad == 'h0)
      register[0] <= 'h0;
    else
      register[w_ad] <= w_data;
      reg_v_n[w_ad] <= 'b0;
  end
end

always_latch begin
  if(block_rd && rd != 'h0)
    reg_v_n[rd] <= 'b1;
end

always begin
  if(flush) begin
    for(int i = 0; i < 32; i++)
      reg_v_n[i] = 1'h0;
  end
end

endmodule
