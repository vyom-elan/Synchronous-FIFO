
class fifo_base_vseq extends dv_base_vseq #(
    .CFG_T               (fifo_env_cfg),
    .COV_T               (fifo_env_cov),
    .VIRTUAL_SEQUENCER_T (fifo_virtual_sequencer)
  );
  `uvm_object_utils(fifo_base_vseq)

  // various knobs to enable certain routines
  bit do_fifo_init = 1'b1;

  // This handle is needed for the uvm_do macros to operate on.
  fifo_item req;

  `uvm_object_new

   // We can leave dut_init and dut_shutdown as is.
  // The base class versions are sufficient for now.
  // virtual task dut_init(string reset_kind = "HARD");
  //   super.dut_init();
  //   if (do_fifo_init) fifo_init();
  // endtask

  // virtual task dut_shutdown();
  //   // check for pending fifo operations and wait for them to complete
  //   // TODO
  // endtask

  // setup basic fifo features
  // For our simple FIFO, there is no software initialization needed.
  // A hardware reset is enough. So we make this task empty.
  virtual task fifo_init();
    `uvm_info(`gfn, "fifo_init() called, nothing to do for this simple FIFO.", UVM_DEBUG)
  endtask

  // Task to write a specific number of items to the FIFO
  virtual task write_fifo(int num_items);
    `uvm_info(`gfn, $sformatf("Executing write_fifo with %0d items", num_items), UVM_LOW)
    repeat (num_items) begin
      `uvm_do_on_with(req, p_sequencer.fifo_sequencer_h, {
        wr_en   == 1;
        rd_en   == 0;
      })
    end
  endtask

  // Task to read a specific number of items from the FIFO
  virtual task read_fifo(int num_items);
    `uvm_info(`gfn, $sformatf("Executing read_fifo with %0d items", num_items), UVM_LOW)
    repeat (num_items) begin
      `uvm_do_on_with(req, p_sequencer.fifo_sequencer_h, {
        wr_en   == 0;
        rd_en   == 1;
      })
    end
  endtask

endclass : fifo_base_vseq
