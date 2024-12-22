

module tb_uart
  (
    input logic rst_n,
    input logic clk
  );

  logic rx;
  logic tx;
  logic rts_n;
  logic cts_n;
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

  initial begin : uart_debug
    // Init sigs
    rx = 1;
    cts_n = 1;
    //bus.Init_slave();

    $display("START");

    //send_frame(8'b10101010, 1'b1);

    $display("END SIMULATION");
    $stop(1);
    // 
  end

  task send_frame;
    input logic [7:0] frame;
    input logic parity;
    begin
      $display("Deb");
      #5 rx = 0;
      $display("start bit = %d", rx);
      for(int i = 0; i < 8; i++) begin
        #5 rx = frame[i];
        $display("rx = %d", rx);
      end
      #5 rx = parity;
      $display("parity = %d", rx);
      #5 rx = 1;
      $display("stop = %d", rx);
    end
  endtask
  
endmodule
