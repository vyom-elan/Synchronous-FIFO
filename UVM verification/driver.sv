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
