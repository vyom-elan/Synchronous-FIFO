
class fifo_env_cfg extends dv_base_env_cfg;

  // ext component cfgs
  rand fifo_agent_cfg m_fifo_agent_cfg;

  // --- ADD THIS LINE ---
  // This flag is used by the base test to enable / disable RAL
  bit has_ral = 0;
  // ---------------------

  `uvm_object_utils_begin(fifo_env_cfg)
    `uvm_field_object(m_fifo_agent_cfg, UVM_DEFAULT)
  `uvm_object_utils_end

  `uvm_object_new

  virtual function void initialize(bit [31:0] csr_base_addr = '1);
    ral_model_names = {}; // The fifo has no RAL model
    super.initialize(csr_base_addr);
    // create fifo agent config obj
    m_fifo_agent_cfg = fifo_agent_cfg::type_id::create("m_fifo_agent_cfg");
  endfunction

endclass
