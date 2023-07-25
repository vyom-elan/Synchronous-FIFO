class FIFO_test_1_sequence extends uvm_sequence#(data_transaction);
	`uvm_object_utils(FIFO_test_1_sequence)
	data_transaction tr;
	function new(string name="data_seq_1");
		super.new(name);
	endfunction
	task body();
		for(int i=0;i<20;i++)begin
			tr=data_transaction::type_id::create("tx_data_tr");
			start_item(tr);
			if(i<10)
				begin	
					if(!tr.randomise()with{tr.put==1'b1;tr.get==1'b0;})
						begin
							`uvm_error("Sequence","Randomisation failure for transaction")
						end
				end
			else
				begin
					
					if(!tr.randomise()with{tr.put==1'b0;tr.get==1'b1;})
						begin
							`uvm_error("Sequence","Randomisation failure for transaction")
						end
				end
			finish_item(tr);
		end
	endtask
endclass

class FIFO_test_2_sequence extends uvm_sequence#(data_transaction);
	`uvm_object_utils(FIFO_test_2_sequence)
	data_transaction tr;
	function new(string name="data_seq_2");
		super.new(name);
	endfunction
	task body();
		for(int i=0;i<40;i++)begin
			tr=data_transaction::type_id::create("rd_tr");
			start_item(tr);
			if(i<4)
				begin	
					if(!tr.randomize()with{tr.put==1'b1;tr.get==1'b0;})
						begin
							`uvm_error("Sequence","Randomisation failure for transaction")
						end
				end
			else
				begin
					
					if(!tr.randomise()with{tr.put==1'b0;tr.get==1'b1;})
						begin
							`uvm_error("Sequence","Randomisation failure for transaction")
						end
				end
			finish_item(tr);
		end
	endtask
endclass

class FIFO_rst_sequence extends uvm_sequence#(rst_transaction);
	`uvm_object_utils(FIFO_rst_sequence)
	rst_transaction tr;
	function new(string name="rst_seq");
		super.new(name);
	endfunction
	task body();
		tr=rst_ransaction::type_id::create("rst_tx_tr");
		start_item(tr);
		tr.rst=1'b1;
		finish_item(tr);
		
		tr=rst_ransaction::type_id::create("rst_tx_tr");
		start_item(tr);
		tr.rst=1'b0;
		finish_item(tr);

	endtask
endclass
