
package fifo_env_pkg;
  // dep packages
  import uvm_pkg::*;
  import top_pkg::*;
  import dv_utils_pkg::*;
  import fifo_agent_pkg::*;
  import dv_lib_pkg::*;
  // --- ADD THIS LINE ---
  import dv_base_reg_pkg::*;
  // ---------------------------

  // macro includes
  `include "uvm_macros.svh"
  `include "dv_macros.svh"

  // parameters

  // types
  typedef dv_base_reg_block fifo_reg_block;

  // functions

  // package sources
  `include "fifo_env_cfg.sv"
  `include "fifo_env_cov.sv"
  `include "fifo_virtual_sequencer.sv"
  `include "fifo_scoreboard.sv"
  `include "fifo_env.sv"
  `include "fifo_vseq_list.sv"

endpackage
