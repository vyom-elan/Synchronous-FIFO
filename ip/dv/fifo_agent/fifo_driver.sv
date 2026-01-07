
class fifo_driver extends dv_base_driver #(.ITEM_T(fifo_item),
                                              .CFG_T (fifo_agent_cfg));
  `uvm_component_utils(fifo_driver)

  // the base class provides the following handles for use:
  // fifo_agent_cfg: cfg

  `uvm_component_new

  virtual task run_phase(uvm_phase phase);
    // base class forks off reset_signals() and get_and_drive() tasks
    super.run_phase(phase);
  endtask

  // reset signals
  virtual task reset_signals();
    cfg.vif.drv_cb.data_in <= '0;
    cfg.vif.drv_cb.wr_en   <= 1'b0;
    cfg.vif.drv_cb.rd_en   <= 1'b0;
  endtask

  // drive trans received from sequencer
  // This task runs forever, getting transactions from the sequencer and driving them.
  virtual task get_and_drive();
    forever begin
      // 1. Get the next transaction from the sequencer. This call blocks
      //    until a sequence provides an item.
      seq_item_port.get_next_item(req);
      // 1.2. CREATE THE RESPONSE: Clone the request to create a response object.
      //    The base driver provides the 'rsp' handle for us.
      $cast(rsp, req.clone());
      // 1.3. LINK THE RESPONSE: Copy the sequence ID information. This is CRITICAL.
      //    It tells the sequencer which request this response is for.
      rsp.set_id_info(req);
      `uvm_info(`gfn, $sformatf("Driving item:\n%0s", req.sprint()), UVM_HIGH)
      // do the driving part
      // 2. Drive the DUT inputs based on the transaction fields.
      //    We use the driver clocking block to ensure we drive the signals
      //    at the correct time relative to the clock edge.
      cfg.vif.drv_cb.data_in <= req.data_in;
      cfg.vif.drv_cb.wr_en   <= req.wr_en;
      cfg.vif.drv_cb.rd_en   <= req.rd_en;

      // 3. Wait for one clock cycle for the transaction to complete.
      @(cfg.vif.drv_cb);

      // 4. Send "item_done" back to the sequencer.
      //    Our simple protocol does not have a response, so we call item_done()
      //    without an argument. This unblocks the sequence, allowing it to
      //    generate the next item.
      `uvm_info(`gfn, "Item drive complete", UVM_HIGH)
      // send rsp back to seq
      // `uvm_info(`gfn, "item sent", UVM_HIGH)
      seq_item_port.item_done();
    end
  endtask

endclass
