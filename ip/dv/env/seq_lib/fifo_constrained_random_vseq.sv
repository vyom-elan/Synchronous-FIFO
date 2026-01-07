// Stress test with constrained random operations.
class fifo_constrained_random_vseq extends fifo_base_vseq;
  `uvm_object_utils(fifo_constrained_random_vseq)
  parameter int FifoDepth = 8;


  rand int unsigned num_trans;
  constraint num_trans_c { num_trans inside {[50:100]}; }

  `uvm_object_new

  task body();
    `uvm_info(`gfn, "Starting FIFO constrained random stress test...", UVM_LOW)

    `uvm_info(`gfn, $sformatf("Performing %0d constrained random operations.", num_trans), UVM_LOW)
    for (int i = 0; i < num_trans; i++) begin
      // Use `uvm_do_with to apply a constraint that PREVENTS
      // simultaneous read and write operations.
      `uvm_do_with(req, { !(wr_en && rd_en); })
    end

    // Cleanup: Drain the FIFO.
    `uvm_info(`gfn, "Cleanup: Draining the FIFO.", UVM_LOW)
    read_fifo(FifoDepth);

    `uvm_info(`gfn, "FIFO constrained random stress test finished.", UVM_LOW)
  endtask : body

endclass : fifo_constrained_random_vseq