

FLAGS = --cc -CFLAGS "-std=c++14" -Wall --trace --trace-structs --timing --build
REMOVE_LINT=   #-Wno-STMTDLY -Wno-UNUSED -Wno-ASSIGNIN 
FIFO_SRCS = fifo.sv
TOP_MODULE = tb_fifo

fifo:
	verilator $(FLAGS) $(PKGS) $(FIFO_SRCS) $(REMOVE_LINT) tb_fifo.sv --top-module $(TOP_MODULE) -exe tb.cpp
