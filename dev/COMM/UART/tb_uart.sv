

module tb_uart
  (
    // Clk & reset
    input logic rst_n,
    input logic clk,

    // Uart
    input  logic rx,
    output logic tx,
    output logic rts_n,
    input  logic cts_n
  );

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
    .rts_n    (rts_n),
    .cts_n    (cts_n),
    .bus      (bus),
    .wakeup   (wakeup),
    .rx_irq   (rx_irq),
    .tx_irq   (tx_irq)
  );

  // DEBUG

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
        bus.aw_valid <= 1;
        bus.w.data <= 2604;
        bus.w_valid <= 1;

        bus.b_ready <= 1'b1;
        if(bus.b_valid == 1'b1)
          conf_cnt <= 32'h1;
      end else if(conf_cnt == 32'h1) begin
        bus.aw.addr <= 32'h1_001C;
        bus.aw_valid <= 1'b1;
        bus.w.data <= 32'h20;
        bus.w_valid <= 1'b1;

        bus.b_ready <= 1'b1;
        if(bus.b_valid == 1'b1)
          conf_cnt <= 32'h2;
      end else if(conf_cnt == 32'h2) begin
        bus.aw.addr <= 32'h1_0010;
        bus.aw_valid <= 1'b1;
        bus.w.data <= 32'h48;
        bus.w_valid <= 1'b1;

        bus.b_ready <= 1'b1;
        if(bus.b_valid == 1'b1)
          conf_cnt <= 32'h3;
      end else if(conf_cnt == 32'h3) begin
        bus.aw.addr <= '0;
        bus.aw_valid <= 1'b0;
        bus.w.data <= '0;
        bus.w_valid <= 1'b0;
        bus.b_ready <= 1'b0;
        conf_cnt <= 32'h3;
      end
    end
  end


endmodule
