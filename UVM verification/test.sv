//fifo test
class top_test_base extends uvm_test; 
  'uvm_component_utils(top_test_base)
  my_environment env_h;
  function new(string name="top_test_base",uvm_component parent);
    super.new(name,parent);
  endfunction
  function void build_phase(uvm_phase phase);
    env_h = my_environment::type_id::create("env_h",this);
  endfunction
  task init_vseq(top_vseq_base vseq);
    vseq.data_sqr_h = env_h.agent_1_h.data_sequencer_h;
    vseq.rst_sqr_h = env_h.agent_2_h.rst_sequencer_h;
  endtask 
endclass: top_test_base

class test_1 extends top_test_base; 
  'uvm_component_utils(test_1)
  vseq_rst_data vseq_h;
  function new(string name ="test_1",uv_component parent);
    super.new(name,parent);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    vseq_h = vseq_rst_data::type_id::create("vseq_h");
  endfunction
  task run_phase(uvm_phase phase);
    phase.raise_objection(this); 
    init_vseq(vseq_h); 
    vseq_h.start(null);  
    phase.drop_objection(this);
  endtask
endclass: test_1
