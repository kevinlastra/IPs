
// AXI4 Interface
// Dont support User port

interface 
  (
    parameter alen = 32,
    parameter xlen = 32,
    parameter idlen = 2
  ) 
  axi4 (input logic clk);

  // Burst types
  enum bit[1:0]
  {
    FIXED    = 2'b00,
    INCR     = 2'b01,
    WRAP     = 2'b10,
    RESERVED = 2'b11
  } AXBurst_t;

  // Sizes types
  enum bit[2:0]
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
  enum bit[1:0]
  {
    OKAY    = 2'b00,
    EXOOKAY = 2'b01,
    SLVERR  = 2'b10,
    DECERR  = 2'b11
  } XRESP_t;

  //
  enum bit[0]
  {
    NORMAL    = 1'b0,
    EXCLUSIVE = 1'b1
  } Lock_t;

  struct {
    // 
    logic bufferable; 
    // 
    logic modifiable;
    // 
    logic RA;
    //
    logic WA;
  } AXCache_t;

  struct {
    // 1: priviledged
    // 0: unpriviledged
    logic priviledge; 
    // 1: Non-secure
    // 0: secure
    logic secure;
    // 1: instruction access
    // 0: data access
    logic access;
  } AXProt_t;
  
  
  struct {
    logic [alen-1:0]  addr;
    AXSize_t          size;
    AXBurst_t         burst;
    AXCache_t         cache;
    AXProt_t          prot;
    logic [idlen-1:0] id;
    logic [7:0]       len;
    Lock_t            lock;
    logic [3:0]       qos;
    logic [3:0]       region;
  } AX_t;

  struct {
    logic             last;
    logic [xlen-1:0]  data;
    logic [-1:0]      strb;
    logic [idlen-1:0] id;
  } W_t;

  struct {
    XRESP_t           resp;
    logic [idlen-1:0] id;
  } B_t;

  struct {
    logic             last;
    logic [xlen-1:0]  data;
    XRESP_t           resp;
    logic [idlen-1:0] id;
  } R_t;

  // Adresse write bus
  AX_t  aw;
  logic aw_valid;
  logic aw_ready;
  // Write bus
  W_t   w;
  logic w_valid;
  logic w_ready;
  // Write response bus
  B_t   b;
  logic b_valid;
  logic b_ready;
  // Adresse read bus
  AX_t  ar;
  logic ar_valid;
  logic ar_ready;
  // Read response
  R_t   r;
  logic r_valid;
  logic r_ready;



  modport master
  (
    output aw,
    output aw_valid,
    input  aw_ready,
    output w,
    output w_valid,
    input  w_ready,
    input  b,
    input  b_valid,
    output b_ready,
    output ar,
    output ar_valid,
    input  ar_ready,
    input  r,
    input  r_valid,
    output r_ready
  );

  modport slave
  (
    input  aw,
    input  aw_valid,
    output aw_ready,
    input  w,
    input  w_valid,
    output w_ready,
    output b,
    output b_valid,
    input  b_ready,
    input  ar,
    input  ar_valid,
    output ar_ready,
    output r,
    output r_valid,
    input  r_ready
  );

endinterface;
