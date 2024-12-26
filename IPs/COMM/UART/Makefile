


FLAGS = --cc -CFLAGS "-std=c++14" -Wall --trace --trace-structs --timing --build --sv
REMOVE_LINT= -Wno-PINCONNECTEMPTY \
					 	 -Wno-UNUSEDSIGNAL \
						 -Wno-UNDRIVEN \
						 -Wno-UNUSEDPARAM
						 
#-Wno-STMTDLY -Wno-UNUSED -Wno-ASSIGNIN 

PKGS = -I ../../BUS/AXI/axi4_pkg.sv

SRCS = ../../BUS/AXI/axi4.sv \
			 ../../UTIL/src/fifo.sv \
			src/uart_defs.sv \
			src/uart_reg.sv \
			src/uart_rx.sv \
			src/uart_tx.sv \
			src/uart.sv

TOP_MODULE = tb_uart

verilator:
	verilator $(FLAGS) $(PKGS) $(SRCS) $(REMOVE_LINT) $(TOP_MODULE).sv --top-module $(TOP_MODULE) -exe tb.cpp
