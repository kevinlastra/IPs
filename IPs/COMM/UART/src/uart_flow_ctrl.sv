

module uart_flow_ctrl
  import uart_defs::*;
 (
  input  logic tck,
  input  logic rst_n,

  output logic rts_n,
  input  logic cts_n,

  input  logic tx_rts_n,
  output logic tx_cts_n,
  output logic tx_enable,

  output logic rx_rts_n,
  input  logic rx_cts_n,
  output logic rx_enable,

  input Config_t uart_config
);

  typedef enum bit[1:0] 
  {  
    IDLE = 0,
    DIST = 1,
    LOCAL = 2
  } FlowCtrl_t;

  FlowCtrl_t state, state_n;

  // Halfduplex port enabling
  logic hd_tx_en;
  logic hd_rx_en;

  always_comb begin
    if(uart_config.mode == HALFDUPLEX) begin
      tx_enable = hd_tx_en;
      rx_enable = hd_rx_en;
    end else if(uart_config.mode == SIMPLEX) begin
      tx_enable = uart_config.master;
      rx_enable = !uart_config.master;
    end else begin
      tx_enable = 1;
      rx_enable = 1;
    end
  end

  always_comb begin
    rts_n = 1;
    tx_cts_n = 1;
    rx_rts_n = 1;

    hd_rx_en = 0;
    hd_rx_en = 0;

    casez (state)
      IDLE : begin
        if(uart_config.mode == FULLDUPLEX ||
           uart_config.mode == HALFDUPLEX) begin
          if(!cts_n) begin
            // Distant TX trying to communicate
            // with local RX
            state_n = DIST;
          end else if(!tx_rts_n) begin
            // Local TX trying to communicate
            // with Distant RX  
            state_n = LOCAL;
          end
        end else if(uart_config.mode == SIMPLEX) begin
          if(uart_config.master && tx_rts_n) begin
            state_n = LOCAL;
          end else if(!uart_config.master && cts_n) begin
            state_n = DIST;
          end
        end
      end
      DIST : begin
        hd_rx_en = uart_config.mode == HALFDUPLEX? 1 : 0;

        rx_rts_n = cts_n;
        rts_n = rx_cts_n;
        if(cts_n)
          state_n = IDLE;
      end
      LOCAL : begin
        hd_tx_en = uart_config.mode == HALFDUPLEX? 1 : 0;

        rts_n = tx_rts_n;
        tx_cts_n = cts_n;
        if(tx_rts_n)
          state_n = IDLE;
      end
      default : begin
        state_n = IDLE;
      end
    endcase
  end

  always_ff @(posedge tck or negedge rst_n) begin
    if(!rst_n) begin
      state <= IDLE;
    end else begin
      state <= state_n;
    end
  end

endmodule
