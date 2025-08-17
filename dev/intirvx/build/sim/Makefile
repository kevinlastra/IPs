

PWD?=.

REMOVE_LINT=-Wno-STMTDLY -Wno-UNUSED -Wno-ASSIGNIN 
FLAGS= --cc -CFLAGS "-std=c++14" -Wall --trace --trace-structs --build --sv

TB= ${PWD}/tb_cpu.sv --top-module tb_cpu
TB-CC=-exe ${PWD}/tb_cpu.cpp
VTB=Vtb_cpu

CPU_PARAMS=$(wildcard ${PWD}/../../rtl/cpu/*_parameters.sv)
CPU_PKG=$(wildcard ${PWD}/../../rtl/cpu/*_pkg.sv)
CPU_SRC=$(wildcard ${PWD}/../../rtl/cpu/*)
FILTER=$(filter-out ${CPU_PKG}, $(filter-out ${CPU_PARAMS}, $(CPU_SRC)))

SRC= \
		${FILTER} \
		$(wildcard ${PWD}/../../rtl/clock/*) \
		$(wildcard ${PWD}/../../rtl/memory/*) \
		$(wildcard ${PWD}/../../rtl/utils/*)

PKGS=../../rtl/cpu/cpu_parameters.sv ../../rtl/cpu/csr_pkg.sv ../../rtl/cpu/interfaces_pkg.sv

all: clean cpu run

display-src: 
	@echo $(SRC)

cpu:
	verilator ${FLAGS} ${PKGS} ${SRC} ${REMOVE_LINT} ${TB} ${TB-CC}

run:
	./obj_dir/${VTB}

clean:
	rm -rf obj_dir *.vcd