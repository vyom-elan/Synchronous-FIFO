
class fifo_env extends dv_base_env #(
    .CFG_T              (fifo_env_cfg),
    .COV_T              (fifo_env_cov),
    .VIRTUAL_SEQUENCER_T(fifo_virtual_sequencer),
    .SCOREBOARD_T       (fifo_scoreboard)
  );
  `uvm_component_utils(fifo_env)

  fifo_agent m_fifo_agent;

  `uvm_component_new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // create components
    m_fifo_agent = fifo_agent::type_id::create("m_fifo_agent", this);
    uvm_config_db#(fifo_agent_cfg)::set(this, "m_fifo_agent*", "cfg", cfg.m_fifo_agent_cfg);
    cfg.m_fifo_agent_cfg.en_cov = cfg.en_cov;
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (cfg.en_scb) begin
      m_fifo_agent.monitor.analysis_port.connect(scoreboard.fifo_fifo.analysis_export);
    end
    if (cfg.is_active && cfg.m_fifo_agent_cfg.is_active) begin
      virtual_sequencer.fifo_sequencer_h = m_fifo_agent.sequencer;
    end
  endfunction

endclass
