package axi_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  int run_for_n_times = 0;

  `include "seq_item.sv"      // was transaction.sv
  `include "sequence.sv"      // was generator.sv
  `include "driver.sv"            // includes driverbase.sv
  `include "receiver.sv"          // includes receiverbase.sv
  `include "agent.sv"
  `include "scoreboard.sv"
  `include "environment.sv"
  `include "test.sv"
endpackage
