class data_sequencer extends uvm_sequencer#(data_transaction);
	`uvm_object_utils(data_sequencer)
	function new(string name="data_sequencer", uvm_component parent);
		super.new(name);
	endfunction
endclass:data_sequencer


class rst_sequencer extends uvm_sequencer#(rst_transaction);
	`uvm_object_utils(rst_sequencer)
	function new(string name="rst_sequencer", uvm_component parent);
		super.new(name);
	endfunction
endclass:rst_sequencer
