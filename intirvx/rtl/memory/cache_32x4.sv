


module cache_32x4
#(parameter base_addresse=20000,
  parameter size=1024,
  parameter xlen=32)
(
    // Global inputs
    input logic clk,
    input logic rst_n,

    // Request
    input logic r_v,
    input logic w_v,
    input logic[31:0] adr,
    input logic[31:0] data,
    input logic[3:0] strobe,

    // Answer
    output logic[xlen-1:0] resp,
    output logic resp_valid,
    output logic resp_error
);

parameter cell_size = 32;
parameter nb_cells = 4;

logic[cell_size*nb_cells-1:0] mem[size-1:0];

logic[31:0] local_adr;
logic[$clog2(size)-1:0] index;        // max 25
logic[3:0]  offset;

logic [31:0] cell_mask;

logic mem_error;

// #############################################################################################
// #                                                                                           #
// #    32 bits address = XXXX XXXX       cell selection  misalign                             #
// #    index = max(25 bits) offset = 7bits      |       /                                     #
// #                                             __x xxxx                                      #
// #                                          7'b110 0000 7'b100 0000 7'b010 0000  7'b000 0000 #
// #   32'b 0000 0000 0000 0000_0000 0000 0 :   |_96_|       |_64_|      |_32_|       |_0_|    #
// #                                                                                           #
// #   32'b 0000 0000 0000 0000_0000 0000 1 :   |_224_|     |_192_|     |_160_|      |_128_|   #
// #                                                                                           #
// #   32'b 0000 0000 0000 0000_0000 0001 0 :   |_352_|     |_320_|     |_288_|      |_256_|   #
// #                                                                                           #
// #############################################################################################



always begin
  local_adr = (adr - base_addresse);
  index = local_adr[($clog2(size)-1)+4:4];
  offset = local_adr[3:0] & 4'b1100;
end

logic db_sup;
logic db_inf;

always @(*) begin
  if((w_v || r_v) && rst_n) begin
    resp_error = !(adr >= base_addresse && adr < base_addresse+size);
    db_sup = adr >= base_addresse;
    db_inf = adr < base_addresse+size;
  end
end

always begin
  if(strobe[0])
    cell_mask[7:0] = 8'hFF;
  if(strobe[1])
    cell_mask[15:8] = 8'hFF;
  if(strobe[2])
    cell_mask[23:16] = 8'hFF;
  if(strobe[3])
    cell_mask[31:24] = 8'hFF;
end


always @(negedge clk or negedge rst_n) begin
  mem_error <= 0;
  resp_valid <= 0;
  if(!rst_n) begin
  end else begin
    if(r_v) begin
      case (offset)
        4'b0000: resp <= mem[index][31:0];
        4'b0100: resp <= mem[index][63:32];
        4'b1000: resp <= mem[index][95:64];
        4'b1100: resp <= mem[index][127:96];
      default:
        mem_error <= 1;
      endcase
      resp_valid <= 1;
    end

    if(rst_n && w_v) begin
      case (offset)
        4'b0000: mem[index][31:0] <= (data & cell_mask);
        4'b0100: mem[index][63:32] <= (data & cell_mask);
        4'b1000: mem[index][95:64] <= (data & cell_mask);
        4'b1100: mem[index][127:96] <= (data & cell_mask);
      default:
        mem_error <= 1;
    endcase
  end
  end
end

endmodule
