//agent1
class my_agent_1 extends uvm_component;
  `uvm_component_utils(my_agent_1)
  
  uvm_analysis_port #(data_transaction) ap;
  data_driver data_driver_h;
  data_sequencer data_sequencer_h;
  my_monitor_1 monitor_1_h;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    data_driver_h = data_driver::type_id::create("data_driver_h", this);
    data_sequencer_h = data_sequencer::type_id::create("data_sequencer_h", this);
    monitor_1_h = my_monitor_1::type_id::create("monitor_1_h", this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    data_driver_h.seq_item_port.connect(data_sequencer_h.seq_item_export);
    ap = monitor_1_h.ap;
  endfunction
endclass: my_agent_1

//agent2
class my_agent_2 extends uvm_component;
  `uvm_component_utils(my_agent_2)
  
  rst_driver rst_driver_h;
  rst_sequencer rst_sequencer_h;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    rst_driver_h = rst_driver::type_id::create("rst_driver_h", this);
    rst_sequencer_h = rst_sequencer::type_id::create("rst_sequencer_h", this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    rst_driver_h.seq_item_port.connect(rst_sequencer_h.seq_item_export);
  endfunction
endclass: my_agent_2

//agent3

class my_agent_3 extends uvm_component;
  `uvm_component_utils(my_agent_3)
  
  uvm_analysis_port #(data_transaction) ap;
  my_monitor_2 monitor_2_h;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor_2_h = my_monitor_2::type_id::create("monitor_2_h", this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    ap = monitor_2_h.ap;
  endfunction
endclass: my_agent_3
