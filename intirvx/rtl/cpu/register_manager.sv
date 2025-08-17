



module register_manager
import cpu_parameters::*;
import interfaces_pkg::*;
(
  // Global interface
  input logic clk,
  input logic rst_n,

  // Pc_gen interface
  input decode_bus decode,
  input logic[24:0] instruction,
  input logic[xlen-1:0] pc_i,
  output logic ok_o,
  input logic[xlen-1:0] jal_res_i,
  
  // Calculations units interface
  output decode_bus decode_o,
  output logic[xlen-1:0] pc_o,
  output logic[xlen-1:0] rs1_o,
  output logic[xlen-1:0] rs2_o,
  output logic[4:0] rd_o,
  output logic[xlen-1:0] immediate_o,
  output logic[xlen-1:0] jal_res_o,
  output logic instret_v,

  input logic flush,
  input logic ok_i,

  // Answer from the calculation units
  input logic[xlen-1:0] res_data,
  input logic[4:0] res_adr,
  input logic res_v
);

logic[4:0] rs1_ad;
logic[4:0] rs2_ad;

//pipeline signals
logic[$bits(decode)+
      $bits(pc_i)+
      $bits(rs1)+ 
      $bits(rs2)+ 
      $bits(rd)+
      $bits(rd_v)+
      $bits(immediate)+
      $bits(jal_res_i)+
      $bits(dispatch)+
      $bits(branch_instr)-1:0] data_i, data_o;

logic[xlen-1:0] rs1;
logic rs1_v;
logic[xlen-1:0] rs2;
logic rs2_v;
logic[4:0] rd;
logic rd_v;
logic rd_v_o;

logic[xlen-1:0] immediate;

logic[11:0] s_imm;
logic s_imm_v;
logic[19:0] l_imm;
logic l_imm_v;

logic branch_instr;
logic branch_instr_o;
logic dispatch;


always begin
  rd = instruction[4:0];
  rs1_ad = instruction[12:8];
  rs2_ad = instruction[17:13];

  if((decode.unit == 2'h0 && decode.sub_unit == 3'h1) || (decode.unit == 2'h1 && decode.sub_unit == 3'h1))
    s_imm = {instruction[24:18], instruction[4:0]};
  else
    s_imm = {instruction[24:13]};

  l_imm = instruction[24:5];
end

always_latch begin
  l_imm_v = 0;
  s_imm_v = 0;

  if(decode.unit == 2'h0 && decode.sub_unit == 3'h0 && decode.sel != 4'h3) begin
    l_imm_v = 1;
  end else if(decode.imm | (decode.unit == 2'h2)) begin
    s_imm_v = 1;
  end

  // if ALU sub 0 and not jarl then the rs1 is not used
  rs1_v = !l_imm_v;

  // if ALU and not immediate or SX
  rs2_v = (decode.unit == 2'h0 && decode.sub_unit != 3'h0 && (!decode.imm | decode.sub_unit == 3'h1)) | (decode.unit == 2'h1 && decode.sub_unit == 3'h1);

  branch_instr = (decode.unit == 2'h0 && decode.sub_unit == 3'h1) || 
                 (decode.unit == 2'h0 && decode.sub_unit == 3'h0 && decode.sel == 4'h3);

  // if not branch conditional or store instruction
  rd_v = !(decode.unit == 2'h0 && decode.sub_unit == 3'h1) && !(decode.unit == 2'h1 && decode.sub_unit == 3'h1);
end

always_latch begin
  if(l_imm_v) begin
    if(decode.unit == 2'h0 && decode.sub_unit == 3'h0 && decode.sel == 4'h2) // jal
      immediate = {{12{l_imm[19]}}, l_imm[10:1], l_imm[11], l_imm[19:12], 1'b0};
    else
      immediate = {l_imm, 12'h0};    
  end else if(s_imm_v) begin
    if(decode.unit == 2'h0 && decode.sub_unit == 3'h1) // b
        immediate = {{20{s_imm[11]}}, s_imm[0], s_imm[10:5], s_imm[4:1], 1'b0};
    else
      immediate =  {{20{s_imm[11]}} , s_imm};
  end
end

register_file register_file
(
  .clk,
  .rst_n,
  .w_valid(res_v),
  .w_ad(res_adr),
  .w_data(res_data),
  .r0_valid(rs1_v),
  .r0_ad(rs1_ad),
  .r1_valid(rs2_v),
  .r1_ad(rs2_ad),
  .block_rd(rd_v_o),
  .rd(rd_o),
  .flush(flush),
  .r0_data(rs1),
  .r1_data(rs2),
  .r_v(dispatch)
);


// push data on the pipeline
always begin
  data_i = {
            decode,
            pc_i,
            rs1, 
            rs2, 
            rd,
            rd_v,
            immediate,
            jal_res_i,
            dispatch,
            branch_instr | decode.mret
          };
end

fifo #(.DATA_SIZE($bits(data_i))) pipeline_r2c
(
  .clk(clk),
  .rst_n(rst_n),
  .data_i(data_i),
  .flush(flush | !dispatch | branch_instr_o),
  .ok(ok_i),
  .data_o(data_o)
);

// pull data from the pipeline
always begin
  {
    decode_o,
    pc_o,
    rs1_o,
    rs2_o,
    rd_o,
    rd_v_o,
    immediate_o,
    jal_res_o,
    instret_v,
    branch_instr_o
  } = data_o;
end


always begin
  ok_o = dispatch && ok_i && !branch_instr_o;
end


endmodule
