// ---------------------------------------------------------------------------
// Environment: agent + scoreboard; replaces the mailbox wiring done in build()
//   gen.out_box -> driver in_box   : sequencer/driver connection inside agent
//   drvr.out_box -> sb.driver_mbox : drvr.out_ap -> sb.drv_imp
//   rcvr.out_box -> sb.receiver_mbox: rcvr.out_ap -> sb.rcv_imp
// ---------------------------------------------------------------------------
class axi_env extends uvm_env;
  `uvm_component_utils(axi_env)

  axi_agent  agent;
  scoreboard sb;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent = axi_agent::type_id::create("agent", this);
    sb    = scoreboard::type_id::create("sb", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    agent.drvr.out_ap.connect(sb.drv_imp);
    agent.rcvr.out_ap.connect(sb.rcv_imp);
  endfunction
endclass
