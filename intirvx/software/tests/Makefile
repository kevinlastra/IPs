

PWD=$(shell pwd)

ELF=riscv64-unknown-elf-
GCC=${ELF}gcc
DUMP=${ELF}objdump
COPY=${ELF}objcopy

MARCH=rv32i
MABI=ilp32

TB=Vtb_cpu

FLAGS= -nostdlib -march=${MARCH} -mabi=${MABI} -Wl,-Map,output.map -T ../linkers/riscv32.ld -I/usr/include

TEXT_BASE_ADDRESSE=0x10000
DATA_BASE_ADDRESSE=0x20000

%.riscv : %.o crt0.o
	$(MAKE) $*.dump
	@mv $< $@
	$(MAKE) $*.ihex
	@mv $*.ihex ihex 
	$(MAKE) $*.dhex
	@mv $*.dhex dhex
	../../build/sim/obj_dir/${TB}

crt0.o: 
	${GCC} -nostartfiles ${FLAGS} ../crt0/crt0.c -c

%.o : %.c
	${GCC} ${FLAGS} crt0.o $< -o $@

%.dump : %.o
	${DUMP} -d $< > $*.dump

%.ihex : %.riscv
	${COPY} -O verilog -j .text --change-section-address .text-${TEXT_BASE_ADDRESSE} $< $@
%.dhex : %.riscv
	${COPY} -O verilog -j .data --change-section-address .data-${DATA_BASE_ADDRESSE} $< $@

COMPLIANCE_RV32I_SRC=\
										I-ADD-01 \
										I-ADDI-01 \
										I-AND-01 \
										I-AUIPC-01 \
										I-BEQ-01 \
										I-BGE-01 \
										I-BGEU-01 \
										I-BLT-01 \
										I-BLTU-01 \
										I-BNE-01 \
										I-DELAY_SLOTS-01 \
										I-EBREAK-01 \
										I-ECALL-01 \
										I-ENDIANESS-01 \
										I-IO-01 \
										I-JAL-01 \
										I-JALR-01 \
										I-LB-01 \
										I-LBU-01 \
										I-LH-01 \
										I-LHU-01 \
										I-LUI-01 \
										I-LW-01 \
										I-MISALIGN_JMP-01 \
										I-MISALIGN_LDST-01 \
										I-NOP-01 \
										I-OR-01 \
										I-ORI-01 \
										I-RF_size-01 \
										I-RF_width-01 \
										I-RF_x0-01 \
										I-SB-01 \
										I-SH-01 \
										I-SLL-01 \
										I-SLLI-01 \
										I-SLT-01 \
										I-SLTI-01 \
										I-SLTIU-01 \
										I-SLTU-01 \
										I-SRA-01 \
										I-SRAI-01 \
										I-SRL-01 \
										I-SRLI-01 \
										I-SUB-01 \
										I-SW-01 \
										I-XOR-01 \
										I-XORI-01 

compliance_all: clean compliance_setup compliance_run_all

compliance_setup:
	cd compliance && make all_variant

compliance_run_all:
	@for i in $(COMPLIANCE_RV32I_SRC) ; do \
		mv ./compliance/work/rv32i/$$i.elf .; \
		${DUMP} -d $$i.elf > $$i.dump; \
		${COPY} -O verilog -j .text.init --change-section-address .text.init-${TEXT_BASE_ADDRESSE} $$i.elf ihex; \
		${COPY} -O verilog -j .data --change-section-address .data-${DATA_BASE_ADDRESSE} $$i.elf dhex; \
		echo "Running $$i.\n"; \
		../../build/sim/obj_dir/${TB}; \
		echo "\n\n"; \
		rm ihex dhex *.elf *.dump; \
	done

PROG ?= I-ADD-01
compliance_run: clean compliance_setup
	mv ./compliance/work/rv32i/${PROG}.elf .
	${DUMP} -d ${PROG}.elf > ${PROG}.dump
	${COPY} -O verilog -j .text.init --change-section-address .text.init-${TEXT_BASE_ADDRESSE} ${PROG}.elf ihex
	${COPY} -O verilog -j .data --change-section-address .data-${DATA_BASE_ADDRESSE} ${PROG}.elf dhex
	echo "Running ${PROG}.\n"
	../../build/sim/obj_dir/${TB}

clean:
	rm -f *.o *.riscv *.dump ihex dhex *.vcd base_tests/*.riscv base_tests/*.dump *.elf *.map; \
	cd ./compliance; \
	make clean