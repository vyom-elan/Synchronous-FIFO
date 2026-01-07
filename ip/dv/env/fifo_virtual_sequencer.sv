
class fifo_virtual_sequencer extends dv_base_virtual_sequencer #(
    .CFG_T(fifo_env_cfg),
    .COV_T(fifo_env_cov)
  );
  `uvm_component_utils(fifo_virtual_sequencer)

  fifo_sequencer fifo_sequencer_h;

  `uvm_component_new

endclass
