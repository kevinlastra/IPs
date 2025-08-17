

package axi4_pkg;
  
    // Burst types
  typedef enum bit[1:0]
  {
    FIXED    = 2'b00,
    INCR     = 2'b01,
    WRAP     = 2'b10,
    RESERVED = 2'b11
  } AXBurst_t;

  // Sizes types
  typedef enum bit[2:0]
  {
    S1   = 3'b000,
    S2   = 3'b001,
    S4   = 3'b010,
    S8   = 3'b011,
    S16  = 3'b100,
    S32  = 3'b101,
    S64  = 3'b110,
    S128 = 3'b111
  } AXSize_t;

  // Responses types
  typedef enum bit[1:0]
  {
    OKAY    = 2'b00,
    EXOOKAY = 2'b01,
    SLVERR  = 2'b10,
    DECERR  = 2'b11
  } XRESP_t;

  //
  typedef enum bit
  {
    NORMAL    = 1'b0,
    EXCLUSIVE = 1'b1
  } Lock_t;

endpackage
