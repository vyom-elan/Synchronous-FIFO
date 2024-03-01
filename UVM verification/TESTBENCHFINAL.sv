//includes coverage
//Coverage achieved=100%
import uvm_pkg::*;
`include "uvm_macros.svh"


// FIFO INTERFACE
interface fifo_intf #(parameter WIDTH = 8);

    logic clk;                                                           // Clock signal
    logic rst;                                                           // Reset signal
    logic wr_en;                                                         // Write enable signal
    logic rd_en;                                                         // Read enable signal
    logic [WIDTH-1:0] data_in;                                           // Input data
    logic empty;                                                         // Empty signal
    logic full;                                                          // Full signal
    logic [WIDTH-1:0] data_out;                                          // Output data

    modport dut       (input clk, rst, wr_en, rd_en, data_in,
                       output empty, full, data_out);                    // Modport for DUT interface
    modport testbench (input empty, full, data_out,
                       output clk, rst, wr_en, rd_en, data_in);          // Modport for testbench interface

endinterface

    covergroup test(virtual fifo_intf intf);                             // Covergroup for monitoring FIFO interface signals
        option.per_instance = 1;
        coverpoint intf.wr_en {
            bins write = {1};
            bins no_write = {0};
        }
        coverpoint intf.rd_en {
            bins read = {1};
            bins no_read = {0};
        }
    endgroup 


//----------------------------------------------------------------------------------------------

// TRANSACTION CLASS
class fifo_transaction extends uvm_sequence_item;

    rand logic [7:0] data_in;                                            // Randomized input data
    rand logic rd_en;                                                    // Read enable flag
    rand logic wr_en;                                                    // Write enable flag
  
    function new(string name = "fifo_transaction");                      // Constructor
        super.new(name);
    endfunction

    `uvm_object_utils_begin(fifo_transaction)                            // Function to display transaction information
        `uvm_field_int(data_in, UVM_ALL_ON)
        `uvm_field_int(rd_en, UVM_ALL_ON)
        `uvm_field_int(wr_en, UVM_ALL_ON)
    `uvm_object_utils_end

endclass

//----------------------------------------------------------------------------------------------------------------

// SEQUENCE
class fifo_test_1_sequence extends uvm_sequence #(fifo_transaction);

    `uvm_object_utils(fifo_test_1_sequence)
    fifo_transaction trans;                                               // Transaction object

    function new(string name = "fifo_seq_1");
        super.new(name);
    endfunction

    task body();                                                          // Sequence body

        for (int i = 0; i < 40; i++) begin

            $display("Inside fifo_test_1_sequence");

            trans = fifo_transaction::type_id::create("tx_fifo_trans");
            start_item(trans);

            $display("Inside fifo_test_1_sequence starting item");

            if (i < 20) begin
                if (!trans.randomize() with {trans.rd_en == 1'b1; trans.wr_en == 1'b0;}) begin
                    `uvm_error("Sequence", "Randomization failure for trasaction")
                end
            end

            else begin
                if (!trans.randomize() with {trans.rd_en == 1'b0; trans.wr_en == 1'b1;}) begin
                    `uvm_error("Sequence", "Randomization failure for trasaction")
                end
            end
            finish_item(trans);
        end
    endtask
endclass : fifo_test_1_sequence


class fifo_test_2_sequence extends uvm_sequence #(fifo_transaction);

    `uvm_object_utils(fifo_test_2_sequence)
    fifo_transaction trans;                                             // transaction class

    function new(string name = "fifo_seq_2");
        super.new(name);
    endfunction

    task body();                                                        // Sequence body

        for (int i = 0; i < 64; i++) begin

            $display("Inside fifo_test_2_sequence");

            trans = fifo_transaction::type_id::create("tx_fifo_trans");
            start_item(trans);

            $display("Inside fifo_test_2_sequence starting item");

            if (i < 8) begin
                if (!trans.randomize() with {trans.rd_en == 1'b1; trans.wr_en == 1'b0;}) begin
                    `uvm_error("Sequence", "Randomization failure for trasaction")
                end
            end

            else begin
                if (!trans.randomize() with {trans.rd_en == 1'b1; trans.wr_en == 1'b1;}) begin
                    `uvm_error("Sequence", "Randomization failure for trasaction")
                end
            end
            finish_item(trans);
        end
    endtask
endclass : fifo_test_2_sequence

//------------------------------------------------------------------------------------------

// SEQUENCER
class fifo_sequencer extends uvm_sequencer#(fifo_transaction);

    `uvm_component_utils(fifo_sequencer)

    function new(string name="fifo_sequencer", uvm_component parent);
        super.new(name);
    endfunction

endclass:fifo_sequencer

//---------------------------------------------------------------------------------------------------

// DRIVER
class fifo_driver extends uvm_driver#(fifo_transaction);

    `uvm_component_utils(fifo_driver)

    virtual fifo_intf#(.WIDTH(8)) intf;                                             // Interface for communication with DUT
    fifo_transaction trans;                                                         // transaction class

    function new(string name = "fifo_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);

        super.build_phase(phase);
        
        // Take the interface configuration from the configuration database
        
        if(!uvm_config_db#(virtual fifo_intf)::get(this,"","fifo_intf",intf))
            `uvm_info("FIFO_DRIVER", "uvm_config_db::get failed!", UVM_HIGH)
    endfunction

    task rst_check();                                                               // Task to handle reset
        forever begin
            @(posedge intf.clk);
            if (intf.rst) begin
                intf.wr_en = 1'b0;
                intf.rd_en = 1'b0;
            end
        end
    endtask

    task send_data();                                                               // Task to send data to DUT
        forever begin                                                               
            @(posedge intf.clk);                                                    
            $display("Inside send_data");                                           
            if (!intf.rst) begin                                                    
                seq_item_port.get_next_item(trans);                                 
                if (trans == null)                                                  // Terminate the loop if no more transactions
                    break;
                trans.print();
                #5
                intf.wr_en   = trans.wr_en;
                intf.rd_en   = trans.rd_en;
                intf.data_in = trans.data_in;
                seq_item_port.item_done();
            end
        end
    endtask

    task run_phase(uvm_phase phase);
        $display("STarting FIFO_DRIVER run_phase \n");
        fork
            rst_check();
            send_data();
        join
    endtask

endclass: fifo_driver

//------------------------------------------------------------------------------------------------

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

// SCOREBOARD
class my_scoreboard extends uvm_scoreboard;
	`uvm_component_utils(my_scoreboard);

    uvm_blocking_get_port #(fifo_transaction) exp_port;         // Expected transaction port
    uvm_blocking_get_port #(fifo_transaction) act_port;	        // Actual transaction port
	
    fifo_transaction fifo_act, fifo_exp;                        // Actual and expected transactions
    
	bit result;                                                 // Result of comparison
    	
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction	
    
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		exp_port = new("exp_port", this);
		act_port = new("act_port", this);		
	endfunction
    
	task run_phase(uvm_phase phase);
		forever begin
            
            $display("Inside scoreboard");

			exp_port.get(fifo_exp);
			act_port.get(fifo_act);
			result = fifo_exp.compare(fifo_act);
			if (result)
				$display("Compare SUCCESSFULLY");
			else begin
                `uvm_warning("WARNING", "Compare FAILED");
            end
                
			$display("The expected data is");
			fifo_exp.print();
			$display("The actual data is");
			fifo_act.print();	
		end
	endtask		
endclass : my_scoreboard

//------------------------------------------------------------------------------------------------

// ENVIRONMENT
class my_environment extends uvm_env;

    `uvm_component_utils(my_environment);
    my_agent_1 agent_1_h;
    my_scoreboard scoreboard_h; 

    uvm_tlm_analysis_fifo #(fifo_transaction) agt_1_scb_fifo;
    uvm_tlm_analysis_fifo #(fifo_transaction) agt_2_scb_fifo;

    function new(string name,uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        agent_1_h      = my_agent_1::type_id::create("agent_1_h",this);
        agt_1_scb_fifo = new("agt_1_scb_fifo",this);
        agt_2_scb_fifo = new("agt_2_scb_fifo",this);
        scoreboard_h = my_scoreboard::type_id::create("scoreboard_h", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        scoreboard_h.exp_port.connect(agt_1_scb_fifo.blocking_get_export);
		scoreboard_h.act_port.connect(agt_2_scb_fifo.blocking_get_export);
    endfunction

endclass: my_environment

//-----------------------------------------------------------------------------------------

// TEST
class top_test_base extends uvm_test;

    `uvm_component_utils(top_test_base)

    my_environment env_h;

    function new(string name = "top_test_base", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        env_h = my_environment::type_id::create("env_h", this);
    endfunction
endclass : top_test_base

class test_1 extends top_test_base;

  `uvm_component_utils(test_1)

  fifo_test_1_sequence test1_seq_h;

    function new(string name = "test_1", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        test1_seq_h = fifo_test_1_sequence::type_id::create("test1_seq_h");
    endfunction

    task run_phase(uvm_phase phase);
        $display("Starting Test1 - fifo_test_1_sequence");
        phase.raise_objection(this);
        test1_seq_h.start(env_h.agent_1_h.fifo_sequencer_h);
        phase.drop_objection(this);
    endtask
endclass : test_1

class test_2 extends top_test_base;

  `uvm_component_utils(test_2)

  fifo_test_2_sequence test2_seq_h;

    function new(string name = "test_2", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        test2_seq_h = fifo_test_2_sequence::type_id::create("test2_seq_h");
    endfunction

    task run_phase(uvm_phase phase);
        $display("Starting Test2 - fifo_test_2_sequence");
        phase.raise_objection(this);
        test2_seq_h.start(env_h.agent_1_h.fifo_sequencer_h);
        phase.drop_objection(this);
    endtask
endclass : test_2

//-----------------------------------------------------------------------------------------

module testbench;

    fifo_intf intf();                               // Instantiate the FIFO interface

    logic       clk;
    logic       rst;

    covergroup intf_coverage @(posedge clk);
        option.per_instance = 1;
        coverpoint intf.wr_en 
        {
            bins write = {1};
            bins no_write = {0};
        }
        coverpoint intf.rd_en 
        {
            bins read = {1};
            bins no_read = {0};
        }
    endgroup : intf_coverage

    intf_coverage cg_inst ;
    test cg_test;

    fifo fifo (
    .clk(intf.clk),
    .rst(intf.rst),
    .wr_en(intf.wr_en),
    .rd_en(intf.rd_en),
    .full(intf.full),
    .empty(intf.empty),
    .data_in(intf.data_in),
    .data_out(intf.data_out)
  );
  
    always @(posedge intf.clk) begin
        cg_inst.sample();                    // Assuming cg_inst is the covergroup instance
    end

    initial begin
        uvm_config_db #(virtual fifo_intf)::set(null, "*", "fifo_intf", intf);
        run_test("test_2");
    end

    initial begin                           // initialize and generate clock and reset
        cg_inst = new();
        cg_test = new(intf);
        intf.clk = 0;
        intf.rst = 1;
        #10 intf.rst = 0;
        $display("Simulation started");
        #1000
        $finish;
    end

    always begin
        #5
        intf.clk = ~intf.clk;
        cg_test.sample();
        $display("Coverage = %0.2f %%", cg_inst.get_inst_coverage());
        $display("Coverage test = %0.2f %%", cg_test.get_inst_coverage());
    end
    
endmodule
