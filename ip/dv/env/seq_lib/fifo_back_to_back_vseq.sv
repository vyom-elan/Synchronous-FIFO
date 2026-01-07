
// Stress test with continuous back-to-back operations.
class fifo_back_to_back_vseq extends fifo_base_vseq;
  `uvm_object_utils(fifo_back_to_back_vseq)
  parameter int FifoDepth = 8;

  `uvm_object_new

    task body();
        `uvm_info(`gfn, "Starting MINIMAL back-to-back test sequence...", UVM_LOW)

        // Phase 1: Fill the FIFO completely with a burst of back-to-back writes.
        `uvm_info(`gfn, "Phase 1: Back-to-back writes.", UVM_LOW)
        write_fifo(FifoDepth);

        // Phase 2: Drain the FIFO completely with a burst of back-to-back reads.
        `uvm_info(`gfn, "Phase 2: Back-to-back reads.", UVM_LOW)
        read_fifo(FifoDepth);

        `uvm_info(`gfn, "MINIMAL back-to-back test sequence finished.", UVM_LOW)
    endtask : body

endclass : fifo_back_to_back_vseq