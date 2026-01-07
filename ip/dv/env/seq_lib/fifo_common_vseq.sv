
class fifo_common_vseq extends fifo_base_vseq;
  `uvm_object_utils(fifo_common_vseq)

  constraint num_trans_c {
    num_trans inside {[1:2]};
  }
  `uvm_object_new

  // This task is empty because this class is not meant to be run directly.
  // It only provides helper tasks for other sequences to use.
  virtual task body();
  endtask : body

endclass
