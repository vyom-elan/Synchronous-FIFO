
// smoke test vseq
class fifo_smoke_vseq extends fifo_base_vseq;
  `uvm_object_utils(fifo_smoke_vseq)
  parameter int FifoWidth = 16;
  parameter int FifoDepth = 8;

  `uvm_object_new

  task body();
    `uvm_info(`gfn, "Starting FIFO smoke test sequence...", UVM_LOW)

    // Phase 1: Use the task from the common sequence to fill the FIFO
    `uvm_info(`gfn, "Phase 1: Filling the FIFO", UVM_LOW)
    write_fifo(FifoDepth);

    // Add a small delay for things to settle if needed
    #100ns;

    // Phase 2: Use the task from the common sequence to empty the FIFO
    `uvm_info(`gfn, "Phase 2: Emptying the FIFO", UVM_LOW)
    read_fifo(FifoDepth);

    `uvm_info(`gfn, "FIFO smoke test sequence finished.", UVM_LOW)
  endtask : body

endclass : fifo_smoke_vseq
