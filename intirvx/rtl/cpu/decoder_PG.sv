



module decoder_PG
import cpu_parameters::*;
import interfaces_pkg::*;
(
  input logic[18:0] instruction,
  input logic instruction_v,
  output decode_bus decode
);

// *-----------------------------------------------------------------------------------------------------*
// |                                          TABLE INSTR DECODE                                         |
// *---------*---------------------------------------------------------*--------------------*------------*
// | unit    |                         0: ALU                          |      1: L/S        |   2: CSR   |
// *---------*------------*-----------*--------*------------*----------*---------*----------*------------*
// | subunit | 0: Special | 1: Branch | 2: Add | 3: logique | 4: shift | 0: load | 1: store |      0     |
// *---------*------------*-----------*--------*------------*----------*---------*----------*------------*
// | intrs   |0  lui      |0  beq     |0 add   |0  slt      |0  sll    |0  lb    |0   sb    |0   csrrw   |
// | intrs   |1  auipc    |1  bne     |1 sub   |1  sltu     |1  srl    |1  lh    |1   sh    |1   csrrs   |
// | intrs   |2  jal      |2  blt     |  addi  |2  xor      |2  sra    |2  lw    |2   sw    |2   csrrc   |
// | intrs   |3  jalr     |3  bge     |        |3  or       |   slli   |3  lbu   |          |    csrrwi  |
// | intrs   |            |4  bltu    |        |4  and      |   srli   |4  lhu   |          |    csrrsi  |
// | intrs   |            |5  bgeu    |        |   slti     |   srai   |         |          |    csrrci  |
// | intrs   |            |           |        |   sltiu    |          |         |          |            |
// | intrs   |            |           |        |   xori     |          |         |          |            |
// | intrs   |            |           |        |   ori      |          |         |          |            |
// | intrs   |            |           |        |   andi     |          |         |          |            |
// *---------*------------*-----------*--------*------------*----------*---------*----------*------------*


always  begin
  decode.unit = 0;
  decode.sub_unit = 0;
  decode.sel = 0;
  decode.imm = 0;
  decode.fence = 0;
  decode.ecall = 0;
  decode.ebreak = 0;

  decode.illegal_instr = 0;
  decode.mret   = 0;

  casez (instruction)
    19'b????????????0110111: // LUI
    begin
      decode.unit = 'h0;
      decode.sub_unit = 'h0;
      decode.sel = 'h0;
      decode.imm = 1;
    end
    19'b????????????0010111: // AUIPC
    begin
      decode.unit = 'h0;
      decode.sub_unit = 'h0;
      decode.sel = 'h1;
      decode.imm = 1;
    end
    19'b????????????1101111: // JAL
    begin
      decode.unit = 'h0;
      decode.sub_unit = 'h0;
      decode.sel = 'h2;
      decode.imm = 1;
    end
    19'b?????????0001100111: // JALR
    begin
      decode.unit = 'h0;
      decode.sub_unit = 'h0;
      decode.sel = 'h3;
      decode.imm = 1;
    end
    19'b?????????0001100011: // BEQ
    begin
      decode.unit = 'h0;
      decode.sub_unit = 'h1;
      decode.sel = 'h0;
      decode.imm = 1;
    end
    19'b?????????0011100011: // BNE
    begin
      decode.unit = 'h0;
      decode.sub_unit = 'h1;
      decode.sel = 'h1;
      decode.imm = 1;
    end
    19'b?????????1001100011: // BLT
    begin
      decode.unit = 'h0;
      decode.sub_unit = 'h1;
      decode.sel = 'h2;
      decode.imm = 1;
    end
    19'b?????????1011100011: // BGE
    begin
      decode.unit = 'h0;
      decode.sub_unit = 'h1;
      decode.sel = 'h3;
      decode.imm = 1;
    end
    19'b?????????1101100011: // BLTU
    begin
      decode.unit = 'h0;
      decode.sub_unit = 'h1;
      decode.sel = 'h4;
      decode.imm = 1;
    end
    19'b?????????1111100011: // BGEU
    begin
      decode.unit = 'h0;
      decode.sub_unit = 'h1;
      decode.sel = 'h5;
      decode.imm = 1;
    end
    19'b?????????0000000011: // LB
    begin
      decode.unit = 'h1;
      decode.sub_unit = 'h0;
      decode.sel = 'h0;
      decode.imm = 1;
    end
    19'b?????????0010000011: // LH
    begin
      decode.unit = 'h1;
      decode.sub_unit = 'h0;
      decode.sel = 'h1;
      decode.imm = 1;
    end
    19'b?????????0100000011: // LW
    begin
      decode.unit = 'h1;
      decode.sub_unit = 'h0;
      decode.sel = 'h2;
      decode.imm = 1;
    end
    19'b?????????1000000011: // LBU
    begin
      decode.unit = 'h1;
      decode.sub_unit = 'h0;
      decode.sel = 'h3;
      decode.imm = 1;
    end
    19'b?????????1010000011: // LHU 
    begin
      decode.unit = 'h1;
      decode.sub_unit = 'h0;
      decode.sel = 'h4;
      decode.imm = 1;
    end
    19'b?????????0000100011: // SB 
    begin
      decode.unit = 'h1;
      decode.sub_unit = 'h1;
      decode.sel = 'h0;
      decode.imm = 1;
    end
    19'b?????????0010100011: // SH 
    begin
      decode.unit = 'h1;
      decode.sub_unit = 'h1;
      decode.sel = 'h1;
      decode.imm = 1;
    end
    19'b?????????0100100011: // SW   
    begin
      decode.unit = 'h1;
      decode.sub_unit = 'h1;
      decode.sel = 'h2;
      decode.imm = 1;
    end
    19'b?????????0000010011: // ADDI 
    begin
      decode.unit = 'h0;
      decode.sub_unit = 'h2;
      decode.sel = 'h0;
      decode.imm = 1;
    end
    19'b?????????0100010011: // SLTI 
    begin
      decode.unit = 'h0;
      decode.sub_unit = 'h3;
      decode.sel = 'h0;
      decode.imm = 1;
    end
    19'b?????????0110010011: // SLTIU 
    begin
      decode.unit = 'h0;
      decode.sub_unit = 'h3;
      decode.sel = 'h1;
      decode.imm = 1;
    end
    19'b?????????1000010011: // XORI 
    begin
      decode.unit = 'h0;
      decode.sub_unit = 'h3;
      decode.sel = 'h2;
      decode.imm = 1;
    end
    19'b?????????1100010011: // ORI   
    begin
      decode.unit = 'h0;
      decode.sub_unit = 'h3;
      decode.sel = 'h3;
      decode.imm = 1;
    end
    19'b?????????1110010011: // ANDI 
    begin
      decode.unit = 'h0;
      decode.sub_unit = 'h3;
      decode.sel = 'h4;
      decode.imm = 1;
    end
    19'b0000000??0010010011: // SLLI
    begin
      decode.unit = 'h0;
      decode.sub_unit = 'h4;
      decode.sel = 'h0;
      decode.imm = 1;
    end
    19'b0000000??1010010011: // SRLI
    begin
      decode.unit = 'h0;
      decode.sub_unit = 'h4;
      decode.sel = 'h1;
      decode.imm = 1;
    end
    19'b0100000??1010010011: // SRAI
    begin
      decode.unit = 'h0;
      decode.sub_unit = 'h4;
      decode.sel = 'h1;
      decode.imm = 1;
    end
    19'b0000000??0000110011: // ADD
    begin
      decode.unit = 'h0;
      decode.sub_unit = 'h2;
      decode.sel = 'h0;
    end
    19'b0100000??0000110011: // SUB
    begin
      decode.unit = 'h0;
      decode.sub_unit = 'h2;
      decode.sel = 'h1;
    end
    19'b0000000??0010110011: // SLL
    begin
      decode.unit = 'h0;
      decode.sub_unit = 'h4;
      decode.sel = 'h0;
    end
    19'b0000000??0100110011: // SLT
    begin
      decode.unit = 'h0;
      decode.sub_unit = 'h3;
      decode.sel = 'h0;
    end
    19'b0000000??0110110011: // SLTU
    begin
      decode.unit = 'h0;
      decode.sub_unit = 'h3;
      decode.sel = 'h1;
    end
    19'b0000000??1000110011: // XOR
    begin
      decode.unit = 'h0;
      decode.sub_unit = 'h3;
      decode.sel = 'h2;
    end
    19'b0000000??1010110011: // SRL
    begin
      decode.unit = 'h0;
      decode.sub_unit = 'h4;
      decode.sel = 'h1;
    end
    19'b0100000??1010110011: // SRA
    begin
      decode.unit = 'h0;
      decode.sub_unit = 'h4;
      decode.sel = 'h2;
    end
    19'b0000000??1100110011: // OR
    begin
      decode.unit = 'h0;
      decode.sub_unit = 'h3;
      decode.sel = 'h3;
    end
    19'b0000000??1110110011: // AND
    begin
      decode.unit = 'h0;
      decode.sub_unit = 'h3;
      decode.sel = 'h4;
    end
    19'b0000?????0000001111: // fence
    begin
      decode.fence = 'b1;
    end
    19'b0000000000010001111: // fence.I
    begin
      decode.fence = 'b1;
      decode.imm = 'b1;
    end
    19'b?000000000001110011: // ecall
    begin
      decode.ecall = 'b1;
    end
    19'b0000000010001110011: // ebreak
    begin
      decode.ebreak = 'b1;
    end
    19'b0011000100001110011: // mret
    begin
      decode.mret = 'b1;
    end
    19'b?????????0011110011: // CSRRW
    begin
      decode.unit = 'b10;
      decode.sel = 'b0;
    end
    19'b?????????0101110011: // CSRRS
    begin
      decode.unit = 'b10;
      decode.sel = 'b1;
    end
    19'b?????????0111110011: // CSRRC
    begin
      decode.unit = 'b10;
      decode.sel = 'b10;
    end
    19'b?????????1011110011: // CSRRWI
    begin
      decode.unit = 'b10;
      decode.sel = 'b0;
      decode.imm = 1;
    end
    19'b?????????1101110011: // CSRRSI
    begin
      decode.unit = 'b10;
      decode.sel = 'b1;
      decode.imm = 1;
    end
    19'b?????????1111110011: // CSRRCI
    begin
      decode.unit = 'b10;
      decode.sel = 'b10;
      decode.imm = 1;
    end
    default:
      decode.illegal_instr = instruction_v;
  endcase
end

endmodule
