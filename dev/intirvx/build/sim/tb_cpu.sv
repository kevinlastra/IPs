


module tb_cpu
import cpu_parameters::*;
(
  input logic clk,
  input logic rst_n
);

  axi5 #(.alen(32), .xlen(32), .ilen(5)) i_axi();
  axi5 #(.alen(32), .xlen(32), .ilen(5)) d_axi();

  // CPU
  intirvx cpu 
  (
    .clk            (clk),
    .rst_n          (rst_n),
    .hart_id        (5'h0),
    .i_axi          (i_axi),
    .d_axi          (d_axi)
  );
  
  // memory
  axi5_mem #(.base_addr(32'h10000), .size(4096)) imem
  (
    .clk   (clk),
    .rst_n (rst_n),
    .axi   (d_axi)
  );

  axi5_mem #(.base_addr(32'h20000), .size(16384)) dmem
  (
    .clk   (clk),
    .rst_n (rst_n),
    .axi   (d_axi)
  );

  parameter size = 8192;
  logic[7:0] data[size-1:0];

  int j = 0;
  initial begin
    $display("Loading memory.");
    
    $readmemh("../../software/tests/ihex", data);

    for(int i = 0; i < size; i++) begin
      imem.sram.mem[i][31:0]   = {data[j+3], data[j+2], data[j+1], data[j]};
      j = j + 4;
    end
    //for(int i = 0; i < size; i++) begin
    //  imem.mem[i][31:0]   = {data[j+3], data[j+2], data[j+1], data[j]};
    //  imem.mem[i][63:32]  = {data[j+7], data[j+6], data[j+5], data[j+4]};
    //  imem.mem[i][95:64]  = {data[j+11], data[j+10], data[j+9], data[j+8]};
    //  imem.mem[i][127:96] = {data[j+15], data[j+14], data[j+13], data[j+12]};
    //  j = j + 16;
    //end

    
    
    $readmemh("../../software/tests/dhex", data);      

    j = 0;
    //for(int i = 0; i < size; i++) begin
    //  dmem.mem[i][31:0]   = {data[j+3], data[j+2], data[j+1], data[j]};
    //  dmem.mem[i][63:32]  = {data[j+7], data[j+6], data[j+5], data[j+4]};
    //  dmem.mem[i][95:64]  = {data[j+11], data[j+10], data[j+9], data[j+8]};
    //  dmem.mem[i][127:96] = {data[j+12], data[j+13], data[j+14], data[j+15]};
    //  j = j + 16;
    //end
  end

  always begin
    if(cpu.mem.req_adr == 'hFFFF_FFF0 && cpu.mem.req_write) begin
      $display("Program exit with status %d", cpu.register_manager_i.register_file.register[10]);
      $finish;
      $finish;
    end
  end

endmodule
