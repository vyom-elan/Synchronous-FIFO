
class fifo_item extends uvm_sequence_item;

  parameter int FifoWidth = 16;

  // This is the item that will be randomized and sent to the driver.
  // We take these directly from FIFO_TRANSACTION.sv file.

  // Stimulus fields
  rand logic [FifoWidth-1:0] data_in;
  rand bit                   wr_en;
  rand bit                   rd_en;

  // Observed fields (filled in by the monitor, not randomized by the driver)
  logic                 rst_ni;
  logic [FifoWidth-1:0] data_out;
  logic                 wr_ack;
  logic                 overflow;
  logic                 full;
  logic                 empty;
  logic                 almostfull;
  logic                 almostempty;
  logic                 underflow;

  // We can also copy the constraints from your reference transaction
  constraint wr_en_con {
      wr_en dist {1:=70, 0:=30};
  }

  constraint rd_en_con {
      rd_en dist {1:=30, 0:=70};
  }

  // random variables

  `uvm_object_utils_begin(fifo_item)
    `uvm_field_int(rst_ni, UVM_DEFAULT)
    `uvm_field_int(data_in, UVM_DEFAULT)
    `uvm_field_int(wr_en, UVM_DEFAULT)
    `uvm_field_int(rd_en, UVM_DEFAULT)
    `uvm_field_int(data_out, UVM_DEFAULT)
    `uvm_field_int(wr_ack, UVM_DEFAULT)
    `uvm_field_int(overflow, UVM_DEFAULT)
    `uvm_field_int(full, UVM_DEFAULT)
    `uvm_field_int(empty, UVM_DEFAULT)
    `uvm_field_int(almostfull, UVM_DEFAULT)
    `uvm_field_int(almostempty, UVM_DEFAULT)
    `uvm_field_int(underflow, UVM_DEFAULT)
  `uvm_object_utils_end

  `uvm_object_new

endclass
