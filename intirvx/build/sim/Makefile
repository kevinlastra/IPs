
TB=tb_cpu.sv --top-module tb_cpu
TB-CC=-exe tb_cpu.cpp
VTB=Vtb_cpu

REMOVE_LINT=-Wno-STMTDLY -Wno-UNUSED -Wno-ASSIGNIN 
FLAGS= --cc -CFLAGS "-std=c++11" -Wall --trace --build
SRC=+incdir+../../rtl/cpu \
	 	+incdir+../../rtl/clock \
		+incdir+../../rtl/memory \
	  +incdir+../../rtl/utils 

PKGS=../../rtl/cpu/cpu_parameters.sv ../../rtl/cpu/csr_pkg.sv ../../rtl/cpu/interfaces_pkg.sv

all: clean cpu run

cpu:
	verilator ${FLAGS} ${PKGS} ${SRC} ${REMOVE_LINT} ${TB} ${TB-CC}

run:
	./obj_dir/${VTB}

clean:
	rm -rf obj_dir *.vcd