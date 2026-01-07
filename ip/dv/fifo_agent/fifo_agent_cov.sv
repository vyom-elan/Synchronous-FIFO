
class fifo_agent_cov extends dv_base_agent_cov #(fifo_agent_cfg);
  `uvm_component_utils(fifo_agent_cov)

  // the base class provides the following handles for use:
  // fifo_agent_cfg: cfg
  // State variable to store the value of wr_en from the previous transaction

  // covergroups

  // Covergroup that checks signal states and crosses, adapted from FIFO_COVERAGE.sv
  covergroup fifo_cross_cg with function sample (fifo_item t, bit prev_wr_en);
    option.per_instance = 1;

    // Coverpoints for individual control and status signals
    cp_prev_wr_en: coverpoint prev_wr_en;
    cp_wr_en:      coverpoint t.wr_en;
    cp_rd_en:      coverpoint t.rd_en;
    cp_full:       coverpoint t.full;
    cp_empty:      coverpoint t.empty;
    cp_overflow:   coverpoint t.overflow;
    cp_underflow:  coverpoint t.underflow;
    cp_almostfull: coverpoint t.almostfull;
    cp_almostempty:coverpoint t.almostempty;

    // Cross coverage to check interesting corner cases
    full_cross:       cross cp_wr_en, cp_rd_en, cp_full;
    empty_cross:      cross cp_wr_en, cp_rd_en, cp_empty;
    almostfull_cross: cross cp_wr_en, cp_rd_en, cp_almostfull;
    almostempty_cross:cross cp_wr_en, cp_rd_en, cp_almostempty;

    overflow_cross:   cross cp_prev_wr_en, cp_overflow {
                        // It is illegal for overflow to be high if wr_en is low.
                        illegal_bins no_write_overflow = binsof(cp_prev_wr_en) intersect {0} &&
                                                         binsof(cp_overflow) intersect {1};
                      }
    underflow_cross:  cross cp_rd_en, cp_underflow {
                        // It is illegal for underflow to be high if rd_en is low.
                        illegal_bins no_read_underflow = binsof(cp_rd_en) intersect {0} &&
                                                         binsof(cp_underflow) intersect {1};
                      }
  endgroup : fifo_cross_cg

  function new(string name, uvm_component parent);
    super.new(name, parent);
    // instantiate all covergroups here
    fifo_cross_cg = new();
  endfunction : new

  // This is the main sampling function that the monitor will call.
  // It passes the collected taction to the covergroup's sample method.
  virtual function void sample(fifo_item t, bit prev_wr_en);
    fifo_cross_cg.sample(t, prev_wr_en);
  endfunction

endclass
