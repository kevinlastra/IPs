

package interfaces_pkg;
  import cpu_parameters::*;
  typedef struct packed 
  {
    logic[1:0] unit; //{alu, l/s, csr}
    logic[2:0] sub_unit; 
    logic[3:0] sel;
    logic jal;
    logic branch;
    logic imm;
    logic fence;
    logic ecall;
    logic ebreak;
    logic illegal_instr;
    logic mret;
  } decode_bus;

  typedef struct packed {
    logic [xlen-1:0] data;
    logic [4:0]      adr;
  } wb_bus;

endpackage
