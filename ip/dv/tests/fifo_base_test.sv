
class fifo_base_test extends dv_base_test #(
    .CFG_T(fifo_env_cfg),
    .ENV_T(fifo_env)
  );

  `uvm_component_utils(fifo_base_test)
  `uvm_component_new

  // the base class dv_base_test creates the following instances:
  // fifo_env_cfg: cfg
  // fifo_env:     env

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    cfg.has_ral = 1'b0;
  endfunction
  // the base class also looks up UVM_TEST_SEQ plusarg to create and run that seq in
  // the run_phase; as such, nothing more needs to be done

endclass : fifo_base_test
