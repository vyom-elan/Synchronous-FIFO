
// AGENT
class my_agent_1 extends uvm_component;

    `uvm_component_utils(my_agent_1)

    uvm_analysis_port #(fifo_transaction) ap;                             // Analysis port for transaction
    fifo_driver fifo_driver_h;                                            // Driver instance
    fifo_sequencer fifo_sequencer_h;                                      // Sequencer instance
                                   
    virtual fifo_intf intf;                                               // Virtual interface


    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        fifo_driver_h     = fifo_driver::type_id::create("fifo_driver", this);
        fifo_sequencer_h  = fifo_sequencer::type_id::create("fifo_sequencer", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        fifo_driver_h.seq_item_port.connect(fifo_sequencer_h.seq_item_export);
    endfunction

endclass : my_agent_1

//-------------------------------------------------------------------------------------------------
