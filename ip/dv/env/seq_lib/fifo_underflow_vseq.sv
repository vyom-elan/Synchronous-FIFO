
// Test to verify the underflow mechanism.
class fifo_underflow_vseq extends fifo_base_vseq;
  `uvm_object_utils(fifo_underflow_vseq)
  `uvm_object_new

  task body();
    `uvm_info(`gfn, "Starting FIFO underflow test sequence...", UVM_LOW)

    // Phase 1: The FIFO is empty after reset. Attempt to read from it.
    `uvm_info(`gfn, "Phase 1: Attempting to read from an empty FIFO.", UVM_LOW)
    read_fifo(1);

    // Phase 2: Verify recovery. Write one item.
    `uvm_info(`gfn, "Phase 2: Writing one item to verify recovery.", UVM_LOW)
    write_fifo(1);

    // Phase 3: Read back the item successfully.
    `uvm_info(`gfn, "Phase 3: Reading back the single item.", UVM_LOW)
    read_fifo(1);

    `uvm_info(`gfn, "FIFO underflow test sequence finished.", UVM_LOW)
  endtask : body

endclass : fifo_underflow_vseq