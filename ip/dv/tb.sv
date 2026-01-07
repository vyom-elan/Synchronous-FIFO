
module tb;
  // dep packages
  import uvm_pkg::*;
  import dv_utils_pkg::*;
  import fifo_env_pkg::*;
  import fifo_test_pkg::*;

  // macro includes
  `include "uvm_macros.svh"
  `include "dv_macros.svh"

  wire clk, rst_n;

  // interfaces
  clk_rst_if clk_rst_if(.clk(clk), .rst_n(rst_n));

  // --------------------- MODIFIED SECTION 1 ---------------------
  // Instantiate the FIFO interface.
  // We pass in the parameters we defined earlier and connect it to the
  // same clock and reset wires as the clk_rst_if.
  fifo_if #(
    .FifoWidth(16),
    .FifoDepth(8)
  ) fifo_if (
    .clk_i(clk),
    .rst_ni(rst_n)
  );
  // ------------------- END MODIFIED SECTION 1 -------------------

  // dut
  // --------------------- MODIFIED SECTION 2 ---------------------
  // Instantiate the DUT (Design Under Test).
  // The parameter names must match the DUT's RTL (FIFO_WIDTH).
  // We connect its interface port 'fifoif' to our interface's 'dut' modport.
  fifo #(
    .FIFO_WIDTH(16),
    .FIFO_DEPTH(8)
  ) dut (
    .clk_i                (clk),        // Connect DUT clock to TB clock
    .rst_ni               (rst_n),      // Connect DUT reset to TB reset
    .fifoif               (fifo_if.dut)
  );
  // ------------------- END MODIFIED SECTION 2 -------------------

  initial begin
    // drive clk and rst_n from clk_if
    clk_rst_if.set_active();
    uvm_config_db#(virtual clk_rst_if)::set(null, "*.env", "clk_rst_vif", clk_rst_if);
    uvm_config_db#(virtual fifo_if)::set(null, "*.env.m_fifo_agent*", "vif", fifo_if);
    $timeformat(-12, 0, " ps", 12);
    run_test();
  end

endmodule
