package axi_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  int run_for_n_times = 0;

  `include "axi_seq_item.sv"      // was transaction.sv
  `include "axi_sequence.sv"      // was generator.sv
  `include "driver.sv"            // includes driverbase.sv
  `include "receiver.sv"          // includes receiverbase.sv
  `include "axi_agent.sv"
  `include "axi_scoreboard.sv"
  `include "axi_env.sv"
  `include "axi_test.sv"
endpackage
