

CFLAGS = -Wall -Wno-fatal

FIFO_SRCS = fifo.sv tb_fifo.sv
TOP_MODULE = tb_fifo

fifo:
	verilator --cc $(FIFO_SRCS) --top-module $(TOP_MODULE) $(CFLAGS)
