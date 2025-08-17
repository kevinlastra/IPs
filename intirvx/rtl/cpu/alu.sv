




module alu
import cpu_parameters::*;
(
  // Global interface
  input logic clk,
  input logic rst_n,

  // Register manager interface 
  output logic ok_o,

  input logic[1:0] unit,
  input logic[2:0] sub_unit,
  input logic[3:0] sel,

  input logic[xlen-1:0] rs1,
  input logic[xlen-1:0] rs2,
  input logic[4:0] rd_i,

  input logic[xlen-1:0] pc,
  input logic[xlen-1:0] immediate,
  input logic imm,

  // Write back interface
  output logic result_valid,
  output logic[xlen-1:0] result,
  output logic[4:0] rd_o,
  input logic ok_i,

  // PC control interface
  output logic[xlen-1:0] target,
  output logic target_valid,

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

logic illegal_instr;

logic neg;

always begin
  neg = (sub_unit == 3'h1) || 
        (sub_unit == 3'h2 && sel == 4'h1) || 
        (sub_unit == 3'h3 && (sel == 4'h0 && sel == 4'h1));
end
always begin
  if(imm && sub_unit != 3'h1)
    opb = neg ? ~immediate : immediate;
  else
    opb = neg ? ~rs2 : rs2;
end

always begin
  diff = rs2[31] ^ rs1[31];
end

always begin
  alu_res = rs1 + opb + {31'h0, neg};
end

always begin
  res = 32'h0;
  j_res = 32'h0;
  branch = 0;

  illegal_instr = 0;
  if(valid_instruction) begin
    if(sub_unit == 3'h0) begin
      case (sel)
        4'h00: begin
          res = immediate;
        end
        4'h01: begin
          res = pc + immediate;
        end
        4'h02: begin
          res = pc + 4;
        end 
        4'h03: begin
          res = pc + 4;
          j_res = (immediate + rs1) & 0'hFFFFFFFE;
          branch = 1;
        end
        default: 
        illegal_instr = 1;
      endcase
    end else if(sub_unit == 3'h1) begin
      case (sel)
        4'h0: begin
          branch = alu_res == 0;
        end
        4'h1: begin
          branch = alu_res != 0;
        end
        4'h2: begin
          branch = diff? rs1[31]: alu_res[31];
        end
        4'h3: begin
          branch = diff? rs2[31]: !alu_res[31];
        end
        4'h4: begin
          branch = diff? rs2[31]: alu_res[31];
        end
        4'h5: begin
          branch = diff? rs1[31]: !alu_res[31];
        end
        default: 
          illegal_instr = 1;
      endcase

      if(branch) begin
        j_res = immediate + pc;
      end

    end else if(sub_unit == 3'h2) begin
      res = alu_res;
    end else if(sub_unit == 3'h3) begin
      case (sel)
        4'h0 : begin
          res = {{xlen-1{1'b0}}, diff? rs1[31]: alu_res[31]};
        end
        4'h1 : begin
          res = {{xlen-1{1'b0}}, diff? rs2[31]: alu_res[31]};
        end
        4'h2 : begin
          res = rs1 ^ opb;
        end
        4'h3 : begin
          res = rs1 | opb;
        end 
        4'h4 : begin
          res = rs1 & opb;
        end
        default: 
        illegal_instr = 1;
      endcase
    end else if(sub_unit == 3'h4) begin
      case (sel)
        4'h0 : begin
          res = rs1 << opb;
        end
        4'h1 : begin
          res = rs1 >> opb;
        end
        4'h2 : begin
          res = rs1 <<< opb;
        end 
        default: 
          illegal_instr = 1;
      endcase
    end
  end
end

always begin
  res_v = ~illegal_instr && valid_instruction;
end


always begin
  data_i = 
  {
    branch,
    res_v,
    rd_i,
    res,
    j_res
  };
end

fifo #(.DATA_SIZE($bits(data_i))) pipeline_alu2wb
(
  .clk(clk),
  .rst_n(rst_n),
  .data_i(data_i),
  .flush(flush | !valid_instruction),
  .ok(ok_i),
  .data_o(data_o)
);

always begin
  {
    target_valid,
    result_valid,
    rd_o,
    result,
    target
  } = data_o;
end

always begin
  ok_o = unit == 2'h0;
  valid_instruction = unit == 2'h0;
end

endmodule
