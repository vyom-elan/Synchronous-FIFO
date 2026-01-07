class top_vseq_base extends uvm_sequence#(uvm_sequence_item);
	`uvm_object_utils(top_vseq_base)
	rst_sequencer rst_sqr_h;
	data_sequencer data_sqr_h;
	function new(string name="top_vseq_base");
		super.new(name);
	endfunction
endclass

class vseq_rst_data extends top_vseq_base;
	`uvm_object_utils(vseq_rst_data)
	FIFO_test_1_sequence fifo_data_seq_h;
	FIFO_rst_sequence fifo =_rst_seq_h;
	function new(string name="vseq_rst_data");
		super.new(name);
	endfunction
	task body();
		fifo_data_seq_h=FIFO_test_1_sequence::type_id::create("fifo_data_seq_h");
		fifo_rst_seq_h=FIFO_rst_sequence::type_id::create("fifo_rst_seq_h");
		fork
			fifo_rst_seq_h.start(rst_sqr_h);
			fifo_data_seq_h.start(data_sqr_h);
		join
	endtask
endclass:vseq_rst_data
