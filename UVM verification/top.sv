//fifo top
module top;
  dut_if inf();
  
  FIFO dut (
    .clk(inf.clock),
    .reset(inf.reset),
    .put(inf.put),
    .get(inf.get),
    .full_bar(inf.full_bar),
    .empty_bar(inf.empty_bar),
    .data_in(inf.data_in),
    .data_out(inf.data_out)
  );
  
  initial
    begin
      uvm_config_db #(virtual dut_if)::set(null, "uvm_test_top.env_h.agent_1_h.data_driver_h", "dut_if", inf);
      uvm_config_db #(virtual dut_if)::set(null, "uvm_test_top.env_h.agent_2_h.rst_driver_h", "dut_if", inf);
      uvm_config_db #(virtual dut_if)::set(null, "uvm_test_top.env_h.agent_1_h.monitor_1_h", "dut_if", inf);
      uvm_config_db #(virtual dut_if)::set(null, "uvm_test_top.env_h.agent_3_h.monitor_2_h", "dut_if", inf);
      run_test("test_1");
    end
  
  always
    #5 inf.clock = !inf.clock;
  
  initial
    begin
      inf.clock = 1'b1;
      inf.reset = 1'b1;
      repeat(3) @(posedge inf.clock);
      #5
      inf.reset = 1'b0;
    end
endmodule:top
