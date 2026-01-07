//----------------------------- DESCRIPTION ------------------------------------
//
// Generic clock interface for clock events in various utilities
//
//------------------------------------------------------------------------------

interface clk_if(input logic clk);

  clocking cb @(posedge clk);
  endclocking

  clocking cbn @(negedge clk);
  endclocking

  // Wait for 'n' clocks based of positive clock edge
  task automatic wait_clks(int num_clks);
    repeat (num_clks) @cb;
  endtask

  // Wait for 'n' clocks based of negative clock edge
  task automatic wait_n_clks(int num_clks);
    repeat (num_clks) @cbn;
  endtask

endinterface
