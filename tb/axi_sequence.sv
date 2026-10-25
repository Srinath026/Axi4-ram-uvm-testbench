// ---------------------------------------------------------------------------
// Sequence + Sequencer  (was: generator + run_for_n_times)
// The generator's "run n times" loop now lives in the sequence body.
// ---------------------------------------------------------------------------
class axi_base_sequence extends uvm_sequence#(axi_seq_item);
  `uvm_object_utils(axi_base_sequence)

  rand int unsigned num_trans;
  constraint c_num { num_trans inside {[100:200]}; }   // was environment::valid

  function new(string name = "axi_base_sequence");
    super.new(name);
  endfunction

  task body();
    repeat (num_trans) begin
      req = axi_seq_item::type_id::create("req");
      start_item(req);
      if (!req.randomize())
        `uvm_fatal("SEQ", "randomization of axi_seq_item failed")
      finish_item(req);
    end
  endtask
endclass

typedef uvm_sequencer#(axi_seq_item) axi_sequencer;
