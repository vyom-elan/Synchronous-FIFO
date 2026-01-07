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
