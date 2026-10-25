// ---------------------------------------------------------------------------
// Sequence item  (was: class transaction)
// ---------------------------------------------------------------------------
class axi_seq_item extends uvm_sequence_item;

  rand bit [3:0]  addr;
  rand bit [31:0] w_data;
       bit [31:0] r_data;

  constraint c_wdata { w_data inside {[0:1000]}; }

  `uvm_object_utils_begin(axi_seq_item)
    `uvm_field_int(addr,   UVM_ALL_ON | UVM_HEX)
    `uvm_field_int(w_data, UVM_ALL_ON | UVM_DEC)
    `uvm_field_int(r_data, UVM_ALL_ON | UVM_DEC)
  `uvm_object_utils_end

  function new(string name = "axi_seq_item");
    super.new(name);
  endfunction

  // Same idea as your transaction::compare(): expected w_data vs received r_data
  function bit compare_data(axi_seq_item rcv, ref string message);
    if (w_data != rcv.r_data) begin
      message = $sformatf("r_data mismatch exp =%0d rec=%0d", w_data, rcv.r_data);
      return 0;
    end
    message = "compared successfully";
    return 1;
  endfunction

endclass
