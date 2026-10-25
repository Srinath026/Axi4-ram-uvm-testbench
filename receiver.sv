`include "receiverbase.sv"
// ---------------------------------------------------------------------------
// receiver extends receiverbase (as in your original)
//   out_box -> out_ap (analysis port to scoreboard)
// ---------------------------------------------------------------------------
class receiver extends receiverbase;
	`uvm_component_utils(receiver)

	uvm_analysis_port#(axi_seq_item) out_ap;

	extern function new(string name, uvm_component parent);
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual task run_phase(uvm_phase phase);
endclass

function receiver::new(string name, uvm_component parent);
	super.new(name, parent);
endfunction

function void receiver::build_phase(uvm_phase phase);
	super.build_phase(phase);
	out_ap = new("out_ap", this);
endfunction

task receiver::run_phase(uvm_phase phase);
	forever begin
		axi_seq_item pkt;
		this.recv();
		$cast(pkt, this.trans1.clone());
		this.out_ap.write(pkt);
		$display("recceiver captured data %0h",this.trans1.r_data);
	end
endtask
