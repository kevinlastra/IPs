

package interfaces_pkg;

  typedef struct packed 
  {
    logic[1:0] unit; //{alu, l/s, csr}
    logic[2:0] sub_unit; 
    logic[3:0] sel;
    logic imm;
    logic fence;
    logic ecall;
    logic ebreak;
    logic illegal_instr;
    logic mret;
  } decode_bus;

endpackage