
class fifo_base_seq extends dv_base_seq #(
    .REQ         (fifo_item),
    .CFG_T       (fifo_agent_cfg),
    .SEQUENCER_T (fifo_sequencer)
  );
  `uvm_object_utils(fifo_base_seq)

  `uvm_object_new

  virtual task body();
    `uvm_fatal(`gtn, "Need to override this when you extend from this class!")
  endtask

endclass
