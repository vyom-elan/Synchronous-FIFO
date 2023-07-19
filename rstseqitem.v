class rst_transaction extends uvm_sequence_item;
	logic rst;
	function new(string name="rst_transaction");
		super.new(name);
	endfunction
	`uvm_object_utils_begin(rst_transaction)
	`uvm_field_int(rst,UVM_ALL_ON)
	`uvm_object_utils_end
endclass