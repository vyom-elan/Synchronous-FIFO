class fifo_scoreboard extends dv_base_scoreboard #(
    .CFG_T(fifo_env_cfg),
    .COV_T(fifo_env_cov)
  );
  `uvm_component_utils(fifo_scoreboard)

  parameter int FifoWidth = 16;
  parameter int FifoDepth = 8;

  // local variables

  // TLM agent fifos
  uvm_tlm_analysis_fifo #(fifo_item) fifo_fifo;

  // local queues to hold incoming packets pending comparison
  // fifo_item fifo_q[$];

  // --- Reference Model ---
  // This is the golden model of the FIFO, adapted from FIFO_SCORE.sv.
  logic [FifoWidth-1:0] ref_queue[$];
    // remember what overflow we expect on the next cycle
  bit exp_overflow;
  bit exp_underflow;
    // Expected read-data for next cycle and a valid flag
  logic [FifoWidth-1:0] exp_data;
  bit                  exp_data_valid;



  `uvm_component_new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    fifo_fifo = new("fifo_fifo", this);
  endfunction

  // The connect_phase is where the analysis_fifo is connected to the monitor's
  // analysis_port. The dv_base_scoreboard can handle this automatically if
  // the port and fifo names match. We just need to tell it which agent to connect to.
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction

  // The run_phase just forks off a separate process for each fifo.
  // We only have one, so we just fork 'process_fifo_fifo'.
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    fork
      process_fifo_fifo();
    join_none
  endtask

  // This task contains the main checking logic. It runs forever.
  virtual task process_fifo_fifo();
    fifo_item item;
    forever begin
      // 1. Get the next transaction collected by the monitor.
      fifo_fifo.get(item);
      `uvm_info(`gfn, $sformatf("received fifo item:\n%0s", item.sprint()), UVM_HIGH)

      // Handle Reset
      if (!item.rst_ni) begin
        ref_queue.delete();
        exp_overflow = 0;
        exp_underflow = 0;
        exp_data      = '0;
        exp_data_valid = 0;
        continue; // Skip to the next transaction
      end

      // Compare delayed overflow first
      `DV_CHECK_EQ(item.overflow, exp_overflow, "Overflow Check (delayed)")
      `DV_CHECK_EQ(item.underflow, exp_underflow, "Underflow Check (delayed)")
      // Compare delayed read data (data_out arrives one cycle after the read request)
      if (exp_data_valid) begin
        `DV_CHECK_EQ(item.data_out, exp_data, "Read Data Check (delayed)")
      end



      // ===== Compare DUT outputs to the reference model state BEFORE applying
      //       the inputs sampled at this cycle. This matches DUT latency.
      `DV_CHECK_EQ(item.full,   (ref_queue.size() == FifoDepth), "Full Flag Check (pre-update)")
      `DV_CHECK_EQ(item.empty,  (ref_queue.size() == 0),        "Empty Flag Check (pre-update)")
      `DV_CHECK_EQ(item.almostfull, (ref_queue.size() == FifoDepth - 1), "Almost Full Check (pre-update)")
      `DV_CHECK_EQ(item.almostempty,(ref_queue.size() == 1), "Almost Empty Check (pre-update)")

      // For write/read ack/data: outputs may reflect pre-update state as well.
      // For writes: if ref not full before this cycle then wr_ack is expected 1
      if (item.wr_en) begin
        if (ref_queue.size() < FifoDepth) begin
          `DV_CHECK_EQ(item.wr_ack, 1'b1, "Write Ack Check: Expected ACK on non-full write (pre-update)")
        end else begin
          // do not check overflow here; handled by exp_overflow above
          `DV_CHECK_EQ(item.wr_ack, 1'b0, "Write Ack Check: Expected NO ACK on full write (pre-update)")
        end
      end else begin
        `DV_CHECK_EQ(item.wr_ack, 1'b0, "Write Ack Check: Expected NO ACK when wr_en is low (pre-update)")
      end

      // compute expectation for next cycle overflow
      exp_overflow = (item.wr_en && (ref_queue.size() == FifoDepth));
      exp_underflow = (item.rd_en && (ref_queue.size() == 0));
      // 4. PREDICT THE NEXT DATA: Look at the inputs for THIS cycle (`item.rd_en`)
      //    and predict what the data output will be on the NEXT cycle.
      // compute expected data for next cycle (data_out corresponds to current head)
      if (item.rd_en && ref_queue.size() > 0) begin
        exp_data       = ref_queue[0]; // The data will be the current head of the queue
        exp_data_valid = 1;
      end else begin
        exp_data_valid = 0;
        exp_data       = '0; // Value is don't-care when not valid
      end


      // ===== Now update the reference model using the inputs sampled at this cycle.
      // This models the DUT applying wr_en/rd_en on this cycle (effective for the next comparison).
      // Handle simultaneous wr & rd carefully (commonly FIFO does read and write in same cycle).
      if (item.wr_en && !item.rd_en) begin
        // pure write
        if (ref_queue.size() < FifoDepth) begin
          ref_queue.push_back(item.data_in);
        end else begin
          // overflow: no change to queue
        end
      end else if (!item.wr_en && item.rd_en) begin
        // pure read
        if (ref_queue.size() > 0) begin
          ref_queue.pop_front();
        end else begin
          // underflow: nothing to pop
        end
      end else if (item.wr_en && item.rd_en) begin
        // simultaneous write and read in same cycle:
        // many FIFOs implement this as: pop_front() then push_back(data_in) (or equivalent),
        // so net occupancy may be unchanged. Implement the behavior that matches your DUT.
        if (ref_queue.size() > 0) begin
          // if not empty, pop then push => occupancy unchanged, but data_out was previous head
          ref_queue.pop_front();
          if (ref_queue.size() < FifoDepth) begin
            ref_queue.push_back(item.data_in);
          end
        end else begin
          // empty -> write may succeed (since read has no effect), check your DUT semantics
          if (ref_queue.size() < FifoDepth) ref_queue.push_back(item.data_in);
        end
      end
      // end update
    end
  endtask

  virtual function void reset(string kind = "HARD");
    super.reset(kind);
    // reset local fifos queues and variables
  endfunction

  function void check_phase(uvm_phase phase);
    super.check_phase(phase);
    `DV_EOT_PRINT_TLM_FIFO_CONTENTS(fifo_item, fifo_fifo)
    // post test checks - ensure that all local fifos and queues are empty
    // We can check here if our internal queue is empty, which it should be
    // at the end of a well-behaved test.
    if (ref_queue.size() != 0) begin
      `uvm_error(`gfn, $sformatf("Reference queue is not empty at end of test! Size: %0d",
                                 ref_queue.size()))
    end
  endfunction

endclass
