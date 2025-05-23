
// AXI4 Interface
// Dont support User port

interface axi4
  import axi4_pkg::*;
  #(
    parameter alen = 32,
    parameter xlen = 32,
    parameter idlen = 2
  )
  (input logic clk);

  typedef struct packed {
    // 
    logic bufferable; 
    // 
    logic modifiable;
    // 
    logic RA;
    //
    logic WA;
  } AXCache_t;

  typedef struct packed {
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
  
  
  typedef struct packed {
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

  typedef struct packed {
    logic                last;
    logic [xlen-1:0]     data;
    logic [(xlen/8)-1:0] strb;
    logic [idlen-1:0]    id;
  } W_t;

  typedef struct packed {
    XRESP_t           resp;
    logic [idlen-1:0] id;
  } B_t;

  typedef struct packed {
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

  //function automatic Init_master();
  //  aw       = '0;
  //  aw_valid = 1'b0;
  //  w        = '0;
  //  w_valid  = 1'b0;
  //  b_ready  = 1'b0;
  //  ar       = '0;
  //  ar_valid = 1'b0;
  //  r_ready  = 1'b0;
  //endfunction

  //function automatic Init_slave();
  //  aw_ready = 1'b0;
  //  w_ready  = 1'b0;
  //  b        = '0;
  //  b_valid  = 1'b0;
  //  ar_ready = 1'b0;
  //  r        = '0;
  //  r_valid  = 1'b0;
  //endfunction
  
endinterface;
