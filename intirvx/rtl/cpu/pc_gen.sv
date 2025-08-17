


module pc_gen
import cpu_parameters::*;
import interfaces_pkg::*;
(
  // Global interface
  input logic clk,
  input logic rst_n,
  input logic[xlen-1:0] start_address,

  // Ifetch interface
  input logic[xlen-1:0] instruction,
  input logic instruction_v,
  output logic ok_o,

  // Register interface
  output decode_bus decode_o,
  output logic[24:0] instruction_o,
  output logic[xlen-1:0] pc_o,
  input logic ok_i,
  output logic[xlen-1:0] jal_res,

  // PC control interface
  output logic next_pc_valide,
  output logic[xlen-1:0] next_pc,
  output logic jal_instr,
  input logic flush,
  input logic[xlen-1:0] pc_correction
  );

// local variables

decode_bus decode;

logic[18:0] decode_parse_instr;
logic[24:0] reg_imm_parse_instr;

logic[31:0] jal_imm;

logic[$bits(decode)+
      $bits(reg_imm_parse_instr)+
      $bits(pc)-1:0] data_i, data_o;

logic[xlen-1:0] pc;

logic state_c;
logic init;

logic INIT = 0;
logic NEXT = 1;

always_latch begin
  decode_parse_instr = {instruction[31:25], instruction[21:20], instruction[14:12], instruction[6:0]};
  reg_imm_parse_instr = instruction[31:7];
end

decoder_PG decoder
(
  .instruction(decode_parse_instr),
  .instruction_v(instruction_v),
  .decode(decode)
);

always begin 
  jal_instr = (decode.unit == 2'h0) && 
              (decode.sub_unit == 3'h0) &&
              (decode.sel == 4'h2) && 
              decode.imm;
end

// calc new address
always begin
  jal_imm = 'h0;
  if(rst_n) begin
    case (state_c)
      INIT : begin
        next_pc = start_address;
      end 
      NEXT : begin
        if(ok_i) begin
          if(flush) begin
            next_pc = pc_correction;
          end else if (jal_instr) begin
            jal_imm = {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0};
            next_pc = pc + jal_imm;
          end else begin
            next_pc = pc + 4;
          end
        end
      end
    endcase
  end
end
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    state_c <= INIT;
    init <= 1;
  end else begin
    pc <= next_pc;
    jal_res <= next_pc;

    if(init) begin
      init <= 0;
    end else begin
      state_c <= NEXT;
    end
  end
end

always begin
  data_i = {decode, 
            reg_imm_parse_instr, 
            pc
            };
end

fifo #(.DATA_SIZE($bits(data_i))) pipeline_pg2r
(
  .clk(clk),
  .rst_n(rst_n),
  .data_i(data_i),
  .flush(flush),
  .ok(ok_i),
  .data_o(data_o)
);

always begin
  {decode_o, 
   instruction_o, 
   pc_o
   } = data_o;
end

always begin
  next_pc_valide = ok_i;
  ok_o = ok_i;
end


endmodule
