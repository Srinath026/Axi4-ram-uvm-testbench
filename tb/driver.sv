`include "driverbase.sv"
// ---------------------------------------------------------------------------
// driver extends driverbase (as in your original)
//   in_box  -> seq_item_port (sequencer)
//   out_box -> out_ap (analysis port to scoreboard, carries ref_pkt)
//   semaphore dropped (single driver, get_next_item/item_done serialises)
//   reset() moved here from environment::reset()
// ---------------------------------------------------------------------------
class driver extends driverbase;
	`uvm_component_utils(driver)

	axi_seq_item trans;
	uvm_analysis_port#(axi_seq_item) out_ap;

	extern function new(string name, uvm_component parent);
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual task reset();
	extern virtual task run_phase(uvm_phase phase);
endclass

function driver::new(string name, uvm_component parent);
	super.new(name, parent);
endfunction

function void driver::build_phase(uvm_phase phase);
	super.build_phase(phase);
	out_ap = new("out_ap", this);
endfunction

task driver::reset();
	this.rtr_io.arst <= 1'b1;
	this.rtr_io.cb.axi_awaddr <= 0;
	this.rtr_io.cb.axi_awvalid <= 0;
	this.rtr_io.cb.axi_wdata <= 0;
	this.rtr_io.cb.axi_wvalid <= 0;
	this.rtr_io.cb.axi_bready <= 0;
	this.rtr_io.cb.axi_araddr <= 0;
	this.rtr_io.cb.axi_arvalid <= 0;
	this.rtr_io.cb.axi_rready <= 0;
	repeat(4) @(this.rtr_io.cb);
	this.rtr_io.arst <= 1'b0;
endtask

task driver::run_phase(uvm_phase phase);
	this.reset();
	forever begin
		axi_seq_item ref_pkt;
		seq_item_port.get_next_item(this.trans);
		this.addr   = this.trans.addr;
		this.w_data = this.trans.w_data;
		this.r_data = this.trans.r_data;
		$cast(ref_pkt, this.trans.clone());
		this.out_ap.write(ref_pkt);
		this.send();
		seq_item_port.item_done();
	end
endtask
