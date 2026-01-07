
class fifo_agent extends dv_base_agent #(
  .CFG_T          (fifo_agent_cfg),
  .DRIVER_T       (fifo_driver),
  .SEQUENCER_T    (fifo_sequencer),
  .MONITOR_T      (fifo_monitor),
  .COV_T          (fifo_agent_cov)
);

  `uvm_component_utils(fifo_agent)

  `uvm_component_new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // get fifo_if handle
    if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", cfg.vif)) begin
      `uvm_fatal(`gfn, "failed to get fifo_if handle from uvm_config_db")
    end
  endfunction

endclass
