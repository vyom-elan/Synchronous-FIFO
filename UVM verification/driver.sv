class data_driver extends uvm_driver#(data_transaction);
	`uvm_object_utils(data_driver)
	virtual dut_if driver2dut;
	data_transaction tr;
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual dut_if)::get(this,"","dut_if",driver2dut))
			`uvm_info("DATA_DRIVER", "uvm_config_db::get failed!", UVM_HIGH)
	endfunction
	task reset_check();
		forever begin
		@(posedge driver2dut.clk);
			if(driver2dut.reset)begin
				driver2dut.put=1'b0;
				driver2dut.get=1'b0;
			end
		end
	endtask
		task send_data();
			forever begin
			@(posedge driver2dut.clk);
				if(!driver2dut.reset)begin
					seq.item_port.get_next_item(tr);
					#1
					driver2dut.put=tr.put;
					driver2dut.get=tr.get;
					driver2dut.data_in=tr.data_in;
					seq_item_port.item_done();
				end
			end
		endtask
		task run_phase(uvm_phase phase);
			fork	
				reset_check();
				send_data();
			join
		endtask
endclass:data_driver

class rst_driver extends uvm_driver#(rst_transaction);
	`uvm_object_utils(rst_driver)
	rst_transaction tr;
	virtual dut_if driver2dut;
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction
	function void build_phase(uvm_phase phase);
		if(!uvm_config_db#(virtual dut_if)::get(this,"","dut_if",driver2dut))
			`uvm_info("RST_DRIVER", "uvm_config_db::get failed!", UVM_HIGH)
	endfunction
	task run_phase(uvm_phase phase);
		seq_item_port.get_next_item(tr);
		driver2dut.reset=tr.rst;
		repeat(5)@(negedge driver2dut.clk);
		seq_item_port.item_done();
		
		seq_item_port.get_next_item(tr);
		driver2dut.reset=tr.rst;
		seq_item_port.item_done();
	endtask
endclass:rst_driver
