


module tb_cpu
import cpu_parameters::*;
(
  input logic clk,
  input logic rst_n
);
  logic[xlen-1:0] start_address = 32'h10000;

  // imem
  logic[xlen-1:0] imem_adr;
  logic[xlen-1:0] imem_resp;
  logic imem_resp_v;
  logic imem_resp_error;

  // dmem
  logic dmem_r_v;
  logic dmem_w_v;
  logic[xlen-1:0] dmem_data_adr;
  logic[xlen-1:0] dmem_data;
  logic[3:0] dmem_strobe;

  logic[xlen-1:0] dmem_res;
  logic dmem_res_v;
  logic dmem_res_error;
  // CPU
  cpu cpu 
  (
    .clk(clk),
    .rst_n(rst_n),
    .start_address(start_address),
    .resp_instruction(imem_resp),
    .resp_instruction_v(imem_resp_v),
    .adr_instruction(imem_adr),
    .r_v(dmem_r_v),
    .w_v(dmem_w_v),
    .data_adr(dmem_data_adr),
    .data_o(dmem_data),
    .strobe(dmem_strobe),
    .dmem_res(dmem_res),
    .dmem_res_v(dmem_res_v),
    .dmem_res_error(dmem_res_error)
  );

  // memory
  cache_32x4 #(.base_addresse(32'h10000), .size(4096), .xlen(xlen)) imem
  (
    .clk(clk),
    .rst_n(rst_n),
    .r_v(1),
    .w_v(0),
    .adr(imem_adr),
    .data(32'h0),
    .strobe(0),
    .resp(imem_resp),
    .resp_valid(imem_resp_v),
    .resp_error(imem_resp_error)
  );

  cache_32x4 #(.base_addresse(32'h20000), .size(16384), .xlen(xlen)) dmem
  (
    .clk(clk),
    .rst_n(rst_n),
    .r_v(dmem_r_v),
    .w_v(dmem_w_v),
    .adr(dmem_data_adr),
    .data(dmem_data),
    .strobe(dmem_strobe),
    .resp(dmem_res),
    .resp_valid(dmem_res_v),
    .resp_error(dmem_res_error)
  );

  parameter size = 8192;
  logic[7:0] data[size-1:0];

  int j = 0;
  initial begin
    $display("Loading memory.");
    
    $readmemh("../../software/tests/ihex", data);

    for(int i = 0; i < size; i++) begin
      imem.mem[i][31:0]   = {data[j+3], data[j+2], data[j+1], data[j]};
      imem.mem[i][63:32]  = {data[j+7], data[j+6], data[j+5], data[j+4]};
      imem.mem[i][95:64]  = {data[j+11], data[j+10], data[j+9], data[j+8]};
      imem.mem[i][127:96] = {data[j+15], data[j+14], data[j+13], data[j+12]};
      j = j + 16;
    end

    
    
    $readmemh("../../software/tests/dhex", data);      

    j = 0;
    for(int i = 0; i < size; i++) begin
      dmem.mem[i][31:0]   = {data[j+3], data[j+2], data[j+1], data[j]};
      dmem.mem[i][63:32]  = {data[j+7], data[j+6], data[j+5], data[j+4]};
      dmem.mem[i][95:64]  = {data[j+11], data[j+10], data[j+9], data[j+8]};
      dmem.mem[i][127:96] = {data[j+12], data[j+13], data[j+14], data[j+15]};

      j = j + 16;
    end
  end

  always begin
    if(cpu.mem.req_adr == 0 && cpu.mem.w_v) begin
      $display("Program exit with status %d", cpu.register_manager.register_file.register[10]);
      $finish;
      $finish;
    end
  end

endmodule
