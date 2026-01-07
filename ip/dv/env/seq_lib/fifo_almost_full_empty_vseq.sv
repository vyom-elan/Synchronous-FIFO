// Test to verify the almost_full and almost_empty mechanisms.
class fifo_almost_full_empty_vseq extends fifo_base_vseq;
  `uvm_object_utils(fifo_almost_full_empty_vseq)
  parameter int FifoDepth = 8;

  `uvm_object_new

  task body();
    `uvm_info(`gfn, "Starting FIFO almost_full/almost_empty test sequence...", UVM_LOW)

    // Phase 1: Test the almost_full boundary
    `uvm_info(`gfn, "Phase 1: Testing almost_full transition.", UVM_LOW)
    // Write 7 items to make the FIFO almost full (count = 7)
    write_fifo(FifoDepth - 1);
    // Write 1 more item to make the FIFO full (count = 8)
    write_fifo(1);
    // Read 1 item to make the FIFO almost full again (count = 7)
    read_fifo(1);

    // Phase 2: Test the almost_empty boundary
    `uvm_info(`gfn, "Phase 2: Testing almost_empty transition.", UVM_LOW)
    // Read 6 more items to make the FIFO almost empty (count = 1)
    read_fifo(FifoDepth - 2);
    // Read 1 more item to make the FIFO empty (count = 0)
    read_fifo(1);
    // Write 1 item to make the FIFO almost empty again (count = 1)
    write_fifo(1);

    // Cleanup: The FIFO contains 1 item. Read it to leave the DUT clean.
    `uvm_info(`gfn, "Cleanup: Draining the FIFO.", UVM_LOW)
    read_fifo(1);

    `uvm_info(`gfn, "FIFO almost_full/almost_empty test sequence finished.", UVM_LOW)
  endtask : body

endclass : fifo_almost_full_empty_vseq