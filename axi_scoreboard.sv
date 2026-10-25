// ---------------------------------------------------------------------------
// Scoreboard - your original logic:
//   driver_mbox   -> drv_imp  (ref packets pushed into refpkt queue)
//   receiver_mbox -> rcv_imp  (each received packet triggers check())
// ---------------------------------------------------------------------------
`uvm_analysis_imp_decl(_drv)
`uvm_analysis_imp_decl(_rcv)

class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)

  uvm_analysis_imp_drv#(axi_seq_item, scoreboard) drv_imp;
  uvm_analysis_imp_rcv#(axi_seq_item, scoreboard) rcv_imp;

  event DONE;
  axi_seq_item refpkt[$];
  axi_seq_item trans1;
  logic [3:0] addr;
  int  pkts_checked = 0;
  int  pass_count   = 0;
  int  fail_count   = 0;
  real coverage_result;

  covergroup cg;
    coverpoint addr;
  endgroup

  function new(string name, uvm_component parent);
    super.new(name, parent);
    cg = new();
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    drv_imp = new("drv_imp", this);
    rcv_imp = new("rcv_imp", this);
  endfunction

  // was: driver_mbox.get(pkt); refpkt.push_back(pkt);
  function void write_drv(axi_seq_item pkt);
    refpkt.push_back(pkt);
  endfunction

  // was: receiver_mbox.get(trans1); check();
  function void write_rcv(axi_seq_item pkt);
    this.trans1 = pkt;
    check();
  endfunction

  function void check();
    string message = "";
    int idx = -1;

    foreach (refpkt[i]) begin
      if (refpkt[i].addr == trans1.addr) begin
        idx = i;
        break;
      end
    end
    if (idx == -1) begin
      message = " no matching reference packet";
      $display("[SB] ERROR : %s for addr=%0h", message, trans1.addr);
      fail_count++;
    end
    else begin
      if (!refpkt[idx].compare_data(trans1, message)) begin
        $display("[SB] error comparing: %s", message);
        fail_count++;
      end
      else
        pass_count++;
      this.addr = refpkt[idx].addr;
      cg.sample();
      refpkt.delete(idx);
    end

    pkts_checked++;
    coverage_result = cg.get_coverage();
    $display(" packets %0d addr=%0h %s coverage=%3.2f", pkts_checked, trans1.addr, message, coverage_result);
    if (pkts_checked >= run_for_n_times)
      ->DONE;
  endfunction

  function void report_phase(uvm_phase phase);
    $display("test completed: PASS=%0d FAIL=%0d", pass_count, fail_count);
    if (fail_count != 0) `uvm_error("SB", "TEST FAILED")
  endfunction
endclass
