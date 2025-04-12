

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

  uart #(.REG_ADDR_MAP(32'h1_0000)) uart_i
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


  typedef struct packed {
      logic [31:0] adr;
      logic        write;
      logic [31:0] data;
  } Debug_t;

  // Set divider to 2604, config FullDuplex and send "Hello word"
  Debug_t tab[22] = {{32'h1_0000, 1'b1, 32'hA2C},
                     {32'h1_001C, 1'b1, 32'h20},
                     {32'h1_0010, 1'b1, 32'h48},
                     {32'h1_0014, 1'b0, 32'h0},
                     {32'h1_0010, 1'b1, 32'h65},
                     {32'h1_0014, 1'b0, 32'h0},
                     {32'h1_0010, 1'b1, 32'h6C},
                     {32'h1_0014, 1'b0, 32'h0},
                     {32'h1_0010, 1'b1, 32'h6C},
                     {32'h1_0014, 1'b0, 32'h0},
                     {32'h1_0010, 1'b1, 32'h6F},
                     {32'h1_0014, 1'b0, 32'h0},
                     {32'h1_0010, 1'b1, 32'h20},
                     {32'h1_0014, 1'b0, 32'h0},
                     {32'h1_0010, 1'b1, 32'h77},
                     {32'h1_0014, 1'b0, 32'h0},
                     {32'h1_0010, 1'b1, 32'h6F},
                     {32'h1_0014, 1'b0, 32'h0},
                     {32'h1_0010, 1'b1, 32'h72},
                     {32'h1_0014, 1'b0, 32'h0},
                     {32'h1_0010, 1'b1, 32'h64},
                     {32'h1_0014, 1'b0, 32'h0}};

  logic [4:0] cnt_d, cnt_q;

  typedef enum bit[2:0] 
  {  
    RST    = 'b000,
    IDLE   = 'b001,
    WREADY = 'b010,
    BRESP  = 'b011,
    RRESP  = 'b100
  } State_t;

  State_t state_d, state_q;

  always_ff @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
      state_q <= RST;
      cnt_q <= 0;
    end else begin
      state_q <= state_d;
      cnt_q <= cnt_d;
    end
  end

  always_comb begin
    state_d = state_q;
    cnt_d = cnt_q;

    bus.aw       = '0;
    bus.aw_valid = 0;

    bus.w        = '0;
    bus.w_valid  = 0;

    bus.ar        = '0;
    bus.ar_valid  = 0;

    bus.b_ready  = 0;
    bus.r_ready  = 0;

    case (state_q)
      RST : begin
        state_d = IDLE;
      end
      IDLE : begin
        if(cnt_q < 22) begin
          if(tab[cnt_q].write) begin
            bus.aw.addr = tab[cnt_q].adr;
            bus.aw_valid = 1;

            bus.w.data = tab[cnt_q].data;
            bus.w_valid = 1;

            if(bus.aw_ready && bus.w_ready) begin
              cnt_d = cnt_q + 1;
              state_d = BRESP;
            end else if(bus.aw_ready) begin
              state_d = WREADY;
            end
          end else begin
            bus.ar.addr = tab[cnt_q].adr;
            bus.ar_valid = 1;
            if(bus.ar_ready) begin
              state_d = RRESP;
            end
          end
        end 
      end 
      WREADY : begin
        bus.w.data = tab[cnt_q].data;
        bus.w_valid = 1;
        
        if(bus.w_ready) begin
          cnt_d = cnt_q + 1;
          state_d = BRESP;
        end
      end
      BRESP : begin
        bus.b_ready = 1;
        if(bus.b_valid)
          state_d = IDLE;
      end
      RRESP : begin
        bus.r_ready = 1;
        if(bus.r_valid) begin
          if(~bus.r.data[1]) begin
            cnt_d = cnt_q + 1;
          end
          state_d = IDLE;
        end
      end
      default: 
        state_d = IDLE;
    endcase
  end

endmodule
