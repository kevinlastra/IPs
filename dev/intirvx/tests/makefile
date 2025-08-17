

TB=tb.sv
TB-CC=tb.cpp
VTB=Vtb


verilate:
	verilator --cc -CFLAGS "-std=c++11" pkg.sv -Wno-UNOPTFLAT tb.sv --top-module tb -exe tb.cpp
