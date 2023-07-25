class data_transaction extends uvm_sequence_item;
	rand logic [15:0] data_in;
	rand logic put;
	rand logic get;
	function new(string name="data_transaction");
		super.new(name);
	endfunction
	`uvm_object_utils_begin(data_transaction)
	`uvm_field_int(data_in,UVM_ALL_ON)
	`uvm_field_int(put,UVM_ALL_ON)
	`uvm_field_int(get,UVM_ALL_ON)
	`uvm_object_utils_end
endclass

class rst_transaction extends uvm_sequence_item;
	logic rst;
	function new(string name="rst_transaction");
		super.new(name);
	endfunction
	`uvm_object_utils_begin(rst_transaction)
	`uvm_field_int(rst,UVM_ALL_ON)
	`uvm_object_utils_end
endclass
