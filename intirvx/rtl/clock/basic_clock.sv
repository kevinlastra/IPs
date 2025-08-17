



module basic_clock
(
    output logic clk
);
parameter period = 10;

initial begin
    clk = 0;

    /* verilator lint_off INFINITELOOP */
    forever begin
        #(period/2) clk = ~clk;
    end
    /* verilator lint_on INFINITELOOP */
end


endmodule