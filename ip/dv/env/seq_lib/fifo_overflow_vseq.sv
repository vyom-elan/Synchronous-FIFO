// Test to verify the overflow mechanism.
class fifo_overflow_vseq extends fifo_base_vseq;
  `uvm_object_utils(fifo_overflow_vseq)
  parameter int FifoDepth = 8;

  `uvm_object_new

  task body();
    `uvm_info(`gfn, "Starting FIFO overflow test sequence...", UVM_LOW)

    // Phase 1: Fill the FIFO completely.
    `uvm_info(`gfn, "Phase 1: Filling the FIFO to capacity.", UVM_LOW)
    write_fifo(FifoDepth);

    // Phase 2: Attempt one more write to trigger the overflow.
    `uvm_info(`gfn, "Phase 2: Attempting to write to a full FIFO.", UVM_LOW)
    write_fifo(1);

    // Phase 3: Recover and verify. Read one item to make space.
    `uvm_info(`gfn, "Phase 3: Reading one item to make space.", UVM_LOW)
    read_fifo(1);

    // Phase 4: Write one more item. This should now succeed without an overflow.
    `uvm_info(`gfn, "Phase 4: Writing into the newly available slot.", UVM_LOW)
    write_fifo(1);

    // Phase 5: Cleanup. Empty the FIFO to leave it in a clean state.
    `uvm_info(`gfn, "Phase 5: Draining the FIFO for cleanup.", UVM_LOW)
    read_fifo(FifoDepth);

    `uvm_info(`gfn, "FIFO overflow test sequence finished.", UVM_LOW)
  endtask : body

endclass : fifo_overflow_vseq