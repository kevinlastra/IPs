


FLAGS = --cc -CFLAGS "-std=c++14" -Wall --trace --trace-structs --timing --build --sv
REMOVE_LINT= -Wno-PINCONNECTEMPTY \
					 	 -Wno-UNUSEDSIGNAL \
						 -Wno-UNDRIVEN \
						 -Wno-UNUSEDPARAM

SRCS = ../../BUS/AXI/axi4_pkg.sv \
			 ../../BUS/AXI/axi4.sv \
	   	 ../../UTIL/FIFO/ASYNC/src/fifo_async.sv \
	   	 src/uart_defs.sv \
	   	 src/uart_csr.sv \
	   	 src/uart_rx.sv \
	   	 src/uart_tx.sv \
	   	 src/uart.sv

all: verilator

verilator:
	verilator $(FLAGS) $(PKGS) $(SRCS) $(REMOVE_LINT) tb_uart.sv --top-module tb_uart -exe tb.cpp
	mv ./obj_dir/Vtb_uart ./tb

coverage:
	verilator $(FLAGS) --coverage $(PKGS) $(SRCS) $(REMOVE_LINT) tb_uart.sv --top-module tb_uart -exe tb.cpp

clean: 
	rm -f *.gtkw
	rm -f *.vcd
	rm -f tb
	rm -rf ./obj_dir