


module tb_cpu
import cpu_parameters::*;
(
  input logic clk,
  input logic rst_n
);

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

  ibus #(.alen(32), .xlen(32)) fetch_bus;

  // CPU
  intirvx cpu 
  (
    .clk            (clk),
    .rst_n          (rst_n),
    .fetch_bus      (fetch_bus),
    .r_v            (dmem_r_v),
    .w_v            (dmem_w_v),
    .data_adr       (dmem_data_adr),
    .data_o         (dmem_data),
    .strobe         (dmem_strobe),
    .dmem_res       (dmem_res),
    .dmem_res_v     (dmem_res_v),
    .dmem_res_error (dmem_res_error)
  );

  assign fetch_bus.req_ready = 1;
  
  // memory
  cache_32x4 #(.base_addresse(32'h10000), .size(4096), .xlen(xlen)) imem
  (
    .clk(clk),
    .rst_n(rst_n),
    .r_v(fetch_bus.req_valid),
    .w_v(0),
    .adr(fetch_bus.req.adr),
    .data(32'h0),
    .strobe(0),
    .resp(fetch_bus.resp.data),
    .resp_error(fetch_bus.resp.status),
    .resp_valid(fetch_bus.resp_valid)
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
    if(cpu.mem.req_adr == 'hFFFF_FFF0 && cpu.mem.w_v) begin
      $display("Program exit with status %d", cpu.register_manager_i.register_file.register[10]);
      $finish;
      $finish;
    end
  end

endmodule
