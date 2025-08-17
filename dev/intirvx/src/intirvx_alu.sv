


module intirvx_alu
import cpu_parameters::*;
import interfaces_pkg::*;
(
  // Global interface
  input logic clk,
  input logic rst_n,

  // Register manager interface 
  input  decode_bus       regman_decode,
  input  logic [xlen-1:0] regman_pc,
  input  logic [xlen-1:0] regman_rs1,
  input  logic [xlen-1:0] regman_rs2,
  input  logic [4:0]      regman_rd,
  input  logic [xlen-1:0] regman_imm,
  input  logic            regman_valid,
  output logic            regman_ready,

  // Write back interface
  output logic [xlen-1:0] alu_result,
  output logic [4:0]      alu_rd,
  // PC control interface
  output logic            alu_jump,
  output logic [xlen-1:0] alu_jump_addr,

  output logic            alu_valid,
  input  logic            alu_ready,

  input logic flush
);

logic[xlen-1:0] opb;
logic[xlen-1:0] alu_res;

logic res_v;
logic branch;
logic[xlen-1:0] res;
logic[xlen-1:0] j_res;

logic[70:0] data_i;
logic[70:0] data_o;

logic eq;
logic less_than;
logic less_than_u;
logic greater_eq;
logic greater_eq_u;
logic diff;

logic valid_instruction;

logic neg;

  assign valid_instruction = regman_decode.unit == 2'h0;

  assign neg = (regman_decode.sub_unit == 3'h1) || 
               (regman_decode.sub_unit == 3'h2 &&  regman_decode.sel == 4'h1) || 
               (regman_decode.sub_unit == 3'h3 && 
                (regman_decode.sel == 4'h0 && 
                 regman_decode.sel == 4'h1));
  always begin
    if(regman_decode.imm && regman_decode.sub_unit != 3'h1)
      opb = neg ? ~regman_imm : regman_imm;
    else
      opb = neg ? ~regman_rs2 : regman_rs2;
  end

  assign diff = regman_rs2[31] ^ regman_rs1[31];

  assign alu_res = regman_rs1 + opb + {31'h0, neg};

  always begin
    res = 32'h0;
    j_res = 32'h0;
    branch = 0;

    if(valid_instruction) begin
      if(regman_decode.sub_unit == 3'h0) begin
        unique case (regman_decode.sel)
          4'b0000: begin
            res = regman_imm;
          end
          4'b0001: begin
            res = regman_pc + regman_imm;
          end
          4'b0010: begin
            res = regman_pc + 4;
          end 
          4'b0011: begin
            res = regman_pc + 4;
            j_res = (regman_imm + regman_rs1) & 0'hFFFFFFFE;
            branch = 1;
          end
          default: begin
            // Nothing
          end
        endcase
      end else if(regman_decode.sub_unit == 3'h1) begin
        unique case (regman_decode.sel)
          4'b0000: begin
            branch = alu_res == 0;
          end
          4'b0001: begin
            branch = alu_res != 0;
          end
          4'b0010: begin
            branch = diff? regman_rs1[31]: alu_res[31];
          end
          4'b0011: begin
            branch = diff? regman_rs2[31]: !alu_res[31];
          end
          4'b0100: begin
            branch = diff? regman_rs2[31]: alu_res[31];
          end
          4'b0101: begin
            branch = diff? regman_rs1[31]: !alu_res[31];
          end
          default: begin
            // Nothing
          end
        endcase

        if(branch) begin
          j_res = regman_imm + regman_pc;
        end

      end else if(regman_decode.sub_unit == 3'h2) begin
        res = alu_res;
      end else if(regman_decode.sub_unit == 3'h3) begin
        unique case (regman_decode.sel)
          4'b0000 : begin
            res = {{xlen-1{1'b0}}, diff? regman_rs1[31]: alu_res[31]};
          end
          4'b0001 : begin
            res = {{xlen-1{1'b0}}, diff? regman_rs2[31]: alu_res[31]};
          end
          4'b0010 : begin
            res = regman_rs1 ^ opb;
          end
          4'b0011 : begin
            res = regman_rs1 | opb;
          end 
          4'b0100 : begin
            res = regman_rs1 & opb;
          end
          default: begin
            // Nothing
          end
        endcase
      end else if(regman_decode.sub_unit == 3'h4) begin
        unique case (regman_decode.sel)
          4'b0000 : begin
            res = regman_rs1 << opb;
          end
          4'b0001 : begin
            res = regman_rs1 >> opb;
          end
          4'b0010 : begin
            res = regman_rs1 <<< opb;
          end
          default: begin
            // Nothing
          end
        endcase
      end
    end
  end

  logic full;
  logic empty;
  
  fifo #(.data_size(70), .buffer_size(1)) pipeline_alu2wb
  (
    .clk       (clk),
    .rst_n     (rst_n),
    .enq_data  ({res, regman_rd, branch, j_res}),
    .enq_valid (regman_valid & valid_instruction),
    .enq_ready (regman_ready),
    .deq_data  ({alu_result, alu_rd, alu_jump, alu_jump_addr}),
    .deq_valid (alu_valid),
    .deq_ready (alu_ready),
    .flush     (flush),
    .full      (full),
    .empty     (empty)
  );

endmodule
