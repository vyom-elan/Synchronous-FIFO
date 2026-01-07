
class fifo_monitor extends dv_base_monitor #(
    .ITEM_T (fifo_item),
    .CFG_T  (fifo_agent_cfg),
    .COV_T  (fifo_agent_cov)
  );
  `uvm_component_utils(fifo_monitor)

  // the base class provides the following handles for use:
  // fifo_agent_cfg: cfg
  // fifo_agent_cov: cov
  // uvm_analysis_port #(fifo_item): analysis_port

  bit prev_wr_en = 0;

  `uvm_component_new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
  endtask

  // collect transactions forever - already forked in dv_base_monitor::run_phase
  // The base monitor class calls this task automatically in a forked process.
  // Our job is to fill it with the logic for collecting transactions.
  virtual protected task collect_trans();
    fifo_item trans;

    forever begin
      // Wait for a positive clock edge. We don't need a clocking block
      // here because our interface is simple. Direct posedge is fine.
      @(posedge cfg.vif.clk_i);

      // After the clock edge, create a transaction and sample the pins.
      // Note: we are sampling directly from the virtual interface, not
      // a clocking block, mirroring the style of the icache_monitor.
      trans = fifo_item::type_id::create("trans");

      trans.rst_ni      = cfg.vif.rst_ni;
      trans.data_in     = cfg.vif.data_in;
      trans.wr_en       = cfg.vif.wr_en;
      trans.rd_en       = cfg.vif.rd_en;
      trans.data_out    = cfg.vif.data_out;
      trans.wr_ack      = cfg.vif.wr_ack;
      trans.overflow    = cfg.vif.overflow;
      trans.full        = cfg.vif.full;
      trans.empty       = cfg.vif.empty;
      trans.almostfull  = cfg.vif.almostfull;
      trans.almostempty = cfg.vif.almostempty;
      trans.underflow   = cfg.vif.underflow;

      // sample the covergroups
      // If coverage is enabled in the agent config, call the sample function
      // in our coverage component, passing in the collected transaction.
      if (cfg.en_cov) begin
        // Call sample with the current transaction AND the previous wr_en
        cov.sample(trans, prev_wr_en);
      end

      // Update the history for the NEXT cycle's sample call
      prev_wr_en = trans.wr_en;

      // write trans to analysis_port
      // Broadcast the collected transaction to the scoreboard.
      analysis_port.write(trans);

    end
  endtask

endclass
