
class fifo_agent_cfg extends dv_base_agent_cfg;

  // interface handle used by driver, monitor & the sequencer, via cfg handle
  virtual fifo_if vif;

  `uvm_object_utils_begin(fifo_agent_cfg)
  `uvm_object_utils_end

  `uvm_object_new

endclass
