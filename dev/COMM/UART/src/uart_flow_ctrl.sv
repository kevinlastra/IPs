

module uart_flow_ctrl
  import uart_defs::*;
 (
  // Clock and reset
  input  logic tck,
  input  logic rst_n,

  // UART interface
  output logic rts_n_o,
  input  logic cts_n_i,

  // TX interface
  input  logic tx_rts_n_i,
  output logic tx_cts_n_o,
  output logic tx_enable_o,

  // RX interface
  output logic rx_rts_n_o,
  input  logic rx_cts_n_i,
  output logic rx_enable_o,

  input Config_t uart_config_i
);

  FCState_t state_q, state;

  // Halfduplex port enabling
  logic hd_tx_en;
  logic hd_rx_en;

  assign tx_enable_o = (uart_config_i.mode == HALFDUPLEX & uart_config_i.mode != SIMPLEX) & hd_tx_en |
                       (uart_config_i.mode != HALFDUPLEX & uart_config_i.mode == SIMPLEX) & uart_config_i.master |
                       (uart_config_i.mode != HALFDUPLEX & uart_config_i.mode != SIMPLEX);

  assign rx_enable_o = (uart_config_i.mode == HALFDUPLEX & uart_config_i.mode != SIMPLEX) & hd_rx_en |
                       (uart_config_i.mode != HALFDUPLEX & uart_config_i.mode == SIMPLEX) & !uart_config_i.master |
                       (uart_config_i.mode != HALFDUPLEX & uart_config_i.mode != SIMPLEX);

  always_comb begin
    state = state_q;

    rts_n_o = 1;
    tx_cts_n_o = 1;
    rx_rts_n_o = 1;

    hd_rx_en = 0;
    hd_rx_en = 0;

    casez (state_q)
      FC_IDLE : begin
        if(uart_config_i.mode == FULLDUPLEX |
           uart_config_i.mode == HALFDUPLEX) begin
          if(~cts_n_i) begin
            // Distant TX trying to communicate
            // with local RX
            state = FC_DIST;
          end else if(~tx_rts_n_i) begin
            // Local TX trying to communicate
            // with Distant RX  
            state = FC_LOCAL;
          end
        end else if(uart_config_i.mode == SIMPLEX) begin
          if(uart_config_i.master & ~tx_rts_n_i) begin
            state = FC_LOCAL;
          end else if(~uart_config_i.master & ~cts_n_i) begin
            state = FC_DIST;
          end
        end
      end
      FC_DIST : begin
        hd_rx_en = uart_config_i.mode == HALFDUPLEX? 1 : 0;

        rx_rts_n_o = cts_n_i;
        rts_n_o = rx_cts_n_i;
        if(cts_n_i)
          state = FC_IDLE;
      end
      FC_LOCAL : begin
        hd_tx_en = uart_config_i.mode == HALFDUPLEX? 1 : 0;

        rts_n_o = tx_rts_n_i;
        tx_cts_n_o = cts_n_i;
        if(tx_rts_n_i)
          state = FC_IDLE;
      end
      default : begin
        state = FC_IDLE;
      end
    endcase
  end

  always_ff @(posedge tck or negedge rst_n) begin
    if(!rst_n) begin
      state_q <= FC_IDLE;
    end else begin
      state_q <= state;
    end
  end

endmodule
