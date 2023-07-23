//fifo environment 
class my_environment extends uvm_env; 
  'uvm_component_utils(my_environment);
  my_agent_1 agent_1_h;
  my_agent_2 agent_2_h;
  my_agent_3 agent_3_h;
  my_scoreboard scoreboard_h;
  uvm_tlm_analysis_fifo #(data_transaction)  
  agt_1_scb_fifo;
  uvm_tlm_analysis_fifo #(data_transaction)
  agt_2_scb_fifo;
  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction
  function void build_phase(uvm_phase phase);
    agent_1_h = my_agent_1::type_id::create("agent_1_h",this);
    agent_2_h = my _agent_2::type_id::create("agent_2_h",this);
    agent_3_h = my_agent_3::type_id::create("agent_3_h",this);
    scoreboard_h = my_scoreboard::type_id::create("scoreboard_h",this);
    agt_1_scb_fifo=new("agt_1_scb_fifo",this);
    agt_2_scb_fifo=new("agt_2_scb_fifo",this);
  endfunction

  function void connect_phase(uvm_phase phase); 
    agent_1_h.ap.connect(agt_1_scb_fifo.analysis_export);
    agent_3_h.ap.connect(agt_2_scb_fifo.analysis_export);
    scoreboard_h.exp_port.connect(agt_1_scb_fifo.blo cking_get_export);
    scoreboard_h.act_port.connect(agt_2_scb_fifo.bloc king_get_export);
  endfunction 
endclass: my_environment
