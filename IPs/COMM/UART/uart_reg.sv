

module 
  #(
    parameter int map = 0;
  ) 
    uart_reg
  (
    // System reset and clock
    input logic rst_n,
    input logic clk,
    
    // Bus
    axi4 bus,

  );

  logic valid_access;
  logic error_access;

  always_comb begin
    error_access;
    if(bus.aw_valid) begin
      if(bus.aw.addr[alen-1:8] == map) 
        valid_access = 1;
      else                              
        error_access = 1;
    end
    if(bus.ar_valid) begin
      if(bus.ar.addr[alen-1:8] == map)
        valid_access = 1;
      else
        error_access = 1;
    end
  end

  always_comb begin
    if(bus.aw_valid && bus.w_valid) begin
      //version_wr = bus.aw.addr[7:0] == 8'h0;
      //error_wr   = bus.aw.addr[7:0] == 8'h4;
    end else if(bus.ar_valid) begin
      version_rd = bus.ar.addr[7:0] == 8'h0;
      error_rd   = bus.ar.addr[7:0] == 8'h4;
    end
  end  

endmodule

