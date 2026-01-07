// MONITOR

// WRITE MONITOR
class my_monitor_1 extends uvm_monitor;
  `uvm_component_utils(my_monitor_1)
  virtual dut_if dut2monitor1;
  uvm_analysis_port #(data_transaction)ap;
  data_transaction tr;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ap = new("monitor_1_ap", this);
    if(!uvm_config_db #(virtual dut_if)::get(this, "", "dut_if", dut2monitor1))
      $display("monitor_1_uvm_config_db::get failer");
  endfunction
  
  task run_phase(uvm_phase phase);
    forever
      begin
        @(posedge dut2monitor1.clock)
        tr = data_transaction::type_id::create("tr");
        if(!dut2monitor1.reset & dut2monitor1.full_bar & dut2monitor1.put)
          begin
            tr.data_in = dut2monitor1.data_in;
            ap.write(tr);
          end
      end
  endtask
endclass: my_monitor_1

//---------read monitor---------------

class my_monitor_2 extends uvm_monitor;
  `uvm_component_utils(my_monitor_2)
  
  virtual dut_if dut2monitor2;
  uvm_analysis_port #(data_transaction)ap;
  data_transaction tr;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ap = new("monitor_2_ap", this);
    if(!uvm_config_db #(virtual dut_if)::get(this, "", "dut_if", dut2monitor2))
      $display("monitor_2_uvm_config_db::get failer");
  endfunction
  
  task run_phase(uvm_phase phase);
    forever
      begin
        @(posedge dut2monitor2.clock)
        tr = data_transaction::type_id::create("tr");
        if(!dut2monitor2.reset & dut2monitor2.full_bar & dut2monitor2.put)
          begin
            #1
            tr.data_in = dut2monitor2.data_in;
            ap.write(tr);
          end
      end
  endtask
endclass: my_monitor_2
