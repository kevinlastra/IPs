


module intirvx_register_file
import cpu_parameters::*;
(
  // Global interface
  input logic             clk,
  input logic             rst_n,

  // Write back
  input logic [4:0]       w_adr,
  input logic [xlen-1:0]  w_data,
  input logic             w_valid,

  // Read port 0
  input  logic [4:0]      r0_adr,
  input  logic            r0_adr_valid,
  output logic [xlen-1:0] r0_data,
  output logic            r0_data_valid,

  // Read port 1
  input  logic [4:0]      r1_adr,
  input  logic            r1_adr_valid,
  output logic [xlen-1:0] r1_data,
  output logic            r1_data_valid,

  // Destination block
  input  logic [4:0]      rd_adr,
  input logic             rd_valid,

  // Flush register file
  input logic             flush
);

  logic [xlen-1:0] register[31:0];
  logic            register_valid[31:0];

  always_comb begin
    r0_data       = '0;
    r0_data_valid = 0;
    if(r0_adr_valid) begin
      r0_data       = register[r0_adr];
      r0_data_valid = register_valid[r0_adr];
    end
  end

  always_comb begin
    r1_data       = '0;
    r1_data_valid = 0;
    if(r1_adr_valid) begin
      r1_data       = register[r1_adr];
      r1_data_valid = register_valid[r0_adr];
    end
  end

  always_ff @(posedge clk) begin
    if(w_valid && w_adr != '0) begin
      register[w_adr] <= w_data;
    end
    register[0] <= '0;
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      register_valid <= '{default: 1};
    end else begin
      if(rd_valid) begin
        register_valid[rd_adr] <= 1'b0;
      end
      if(w_valid) begin
        register_valid[w_adr] <= 1'b1;
      end
    end
  end

endmodule
