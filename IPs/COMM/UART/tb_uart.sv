

module tb_uart
  (
    input logic rst_n,
    input logic clk
  );

  logic rx;
  logic tx;

`ifdef VERILATOR
  logic rts_in_n;
  logic rts_out_n;
  logic cts_in_n;
  logic cts_out_n;
`else
  logic rts_n;
  logic cts_n;
`endif

  logic wakeup;
  logic rx_irq;
  logic tx_irq;

  axi4 #(.alen(32), .xlen(32), .idlen(5)) bus(.clk(clk));

  uart #(.regmap(32'h1_0000)) uart_i 
  (
    .rst_n    (rst_n),
    .clk      (clk),
    .rx       (rx),
    .tx       (tx),
`ifdef VERILATOR
    .rts_in_n  (rts_in_n),
    .rts_out_n (rts_out_n),
    .cts_in_n  (cts_in_n),
    .cts_out_n (cts_out_n),
`else
    .rts_n    (rts_n),
    .cts_n    (cts_n),
`endif
    .bus      (bus),
    .wakeup   (wakeup),
    .rx_irq   (rx_irq),
    .tx_irq   (tx_irq)
  );
  
  // DEBUG 

  logic [31:0] counter;
  logic tck;
  logic reseted;

  logic [31:0] conf_cnt;
  always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      bus.aw.addr <= '0;
      bus.aw_valid <= 1'b0;
      bus.w.data <= '0;
      bus.w_valid <= 1'b0;
      bus.b_ready <= 1'b0;
      conf_cnt <= '0;
    end else begin
      if(conf_cnt == 32'h0) begin
        bus.aw.addr <= 32'h1_0000;
        bus.aw_valid <= 0;
        bus.w.data <= 2604;
        bus.w_valid <= 0;

        bus.b_ready <= 1'b1;
        if(bus.b_valid == 1'b1)
          conf_cnt <= 32'h1;
      end else if(conf_cnt == 32'h1) begin
        bus.aw.addr <= '0;
        bus.aw_valid <= 1'b0;
        bus.w.data <= '0;
        bus.w_valid <= 1'b0;
        bus.b_ready <= 1'b0;
        conf_cnt <= 32'h1;
      end
    end
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      reseted <= 0;
      counter <= 0;
      tck <= 1;
    end else begin
      reseted <= 1;
      counter <= counter + 1;
      if(counter >= 1302) begin
        tck <= !tck;
        counter <= 0;
      end
    end
  end

  logic [99:0] shifter, shifter_n;

  always_comb begin
    cts_in_n = 1'b1;
    shifter_n = shifter >> 1;
  end

  always_ff @(posedge tck or negedge rst_n) begin
    if(!rst_n) begin
      rx <= 1;
      shifter <= {{50{1'b1}}, 12'b100010100101, {38{1'b1}}};
`ifdef VERILATOR
      rts_in_n <= 1'b1;
`else
      rts_n <= 1'b1;
`endif
    end else begin
      rx <= shifter_n[0];
      shifter <= shifter_n;
`ifdef VERILATOR
      rts_in_n <= 1'b0;
`else
      rts_n <= 1'b0;
`endif
    end
  end
  
endmodule
