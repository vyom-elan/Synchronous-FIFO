
package fifo_agent_pkg;
  // dep packages
  import uvm_pkg::*;
  import dv_utils_pkg::*;
  import dv_lib_pkg::*;

  // macro includes
  `include "uvm_macros.svh"
  `include "dv_macros.svh"

  // parameters

  // local types
  // forward declare classes to allow typedefs below
  typedef class fifo_item;
  typedef class fifo_agent_cfg;

  // reuse dv_base_sequencer as is with the right parameter set
  typedef dv_base_sequencer #(.ITEM_T(fifo_item),
                              .CFG_T (fifo_agent_cfg)) fifo_sequencer;

  // functions

  // package sources
  `include "fifo_item.sv"
  `include "fifo_agent_cfg.sv"
  `include "fifo_agent_cov.sv"
  `include "fifo_driver.sv"
  `include "fifo_monitor.sv"
  `include "fifo_agent.sv"
  `include "fifo_seq_list.sv"

endpackage: fifo_agent_pkg
