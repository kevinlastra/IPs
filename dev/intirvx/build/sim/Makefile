

PWD?=.

REMOVE_LINT=-Wno-STMTDLY -Wno-UNUSED -Wno-ASSIGNIN 
FLAGS= --cc -CFLAGS "-std=c++14" -Wall --trace --trace-structs --build --sv

TB= ${PWD}/tb_cpu.sv --top-module tb_cpu
TB-CC=-exe ${PWD}/tb_cpu.cpp
VTB=Vtb_cpu

CPU_PARAMS=$(wildcard ${PWD}/../../src/*_parameters.sv)
CPU_PKG=$(wildcard ${PWD}/../../src/*_pkg.sv)
CPU_SRC=$(wildcard ${PWD}/../../src/*)
FILTER=$(filter-out ${CPU_PKG}, $(filter-out ${CPU_PARAMS}, $(CPU_SRC)))

SRC= \
		${FILTER} \
		$(wildcard ${PWD}/../../../memory/*) \
		$(wildcard ${PWD}/../../../bus/src/*) \
		$(wildcard ${PWD}/../../../util/sync/src/*)

PKGS=../../src/cpu_parameters.sv ../../src/csr_pkg.sv ../../src/interfaces_pkg.sv

all: clean cpu run

display-src: 
	@echo $(SRC)

cpu:
	verilator ${FLAGS} ${PKGS} ${SRC} ${REMOVE_LINT} ${TB} ${TB-CC}

run:
	./obj_dir/${VTB}

clean:
	rm -rf obj_dir *.vcd