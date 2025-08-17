// ============================================================
// IP           : sram_sp
// Author       : Kevin Lastra
// Description  : Single port static RAM
// 
// Revision     : 1.0.0
// 
// License      : MIT License
// ============================================================

module sram_sp
  #(
    parameter depth = 8,
    parameter width = 8
  )
(
    // Global inputs
    input logic clk,

    // Request
    input  logic                     we,
    input  logic                     en,
    input  logic [$clog2(depth)-1:0] addr,
    input  logic [width-1:0]         wdata,
    output logic [width-1:0]         rdata
);

  logic [width-1:0] mem[depth-1:0];

  always_ff @( posedge clk ) begin : ff
    if(en) begin
      if(we) begin
        mem[addr] <= wdata;
      end else begin
        rdata <= mem[addr];
      end
    end
  end

endmodule
