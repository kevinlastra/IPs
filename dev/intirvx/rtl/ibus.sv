

interface ibus
  #(
    parameter  alen = 32,
    parameter  xlen = 32
  )
  ();

  typedef enum bit [0:0] {  
    OK    = 1'b0,
    ERROR = 1'b1
  } Status_t;

  typedef struct packed {
    logic [alen-1:0] adr;
  } Req_t;

  typedef struct packed {
    logic [xlen-1:0] data;
    Status_t         status;
  } Resp_t;

  Req_t   req;
  logic   req_valid;
  logic   req_ready;

  Resp_t  resp;
  logic   resp_valid;
  logic   resp_ready;

  localparam Req_size  = $bits(Req_t);
  localparam Resp_size = $bits(Resp_t);

  modport master (
    output req,
    output req_valid,
    input  req_ready,
    input  resp,
    input  resp_valid,
    output resp_ready
  );

  modport slave (
    input  req,
    input  req_valid,
    output req_ready,
    output resp,
    output resp_valid,
    input  resp_ready
  );

endinterface //ibus
