// ---------------------------------------------------------------------------
// Interface (same signals as your original `infc`)
//   cb  : driver clocking block  (TB drives, DUT responds)
//   mcb : monitor clocking block (everything is an input)
// ---------------------------------------------------------------------------
interface infc(input logic aclk);
  logic        arst;

  logic [3:0]  axi_awaddr;
  logic        axi_awvalid;
  logic        axi_awready;

  logic [31:0] axi_wdata;
  logic        axi_wvalid;
  logic        axi_wready;

  logic [1:0]  axi_bresp;
  logic        axi_bvalid;
  logic        axi_bready;

  logic [3:0]  axi_araddr;
  logic        axi_arvalid;
  logic        axi_arready;

  logic [31:0] axi_rdata;
  logic [1:0]  axi_rresp;
  logic        axi_rvalid;
  logic        axi_rready;

  // Driver clocking block
  clocking cb @(posedge aclk);
    output axi_awaddr, axi_awvalid;
    input  axi_awready;
    output axi_wdata, axi_wvalid;
    input  axi_wready;
    input  axi_bresp, axi_bvalid;
    output axi_bready;
    output axi_araddr, axi_arvalid;
    input  axi_arready;
    input  axi_rdata, axi_rresp, axi_rvalid;
    output axi_rready;
  endclocking

  // Monitor clocking block (all inputs).
  // NOTE: your original file declared `mcb` twice and had axi_rready as an
  // output in one of them - that is fixed here.
  clocking mcb @(posedge aclk);
    input axi_awaddr, axi_awvalid, axi_awready;
    input axi_wdata,  axi_wvalid,  axi_wready;
    input axi_bresp,  axi_bvalid,  axi_bready;
    input axi_araddr, axi_arvalid, axi_arready;
    input axi_rdata,  axi_rresp,   axi_rvalid, axi_rready;
  endclocking

  modport tb(clocking cb, clocking mcb, output arst);
endinterface
