// TRANSACTION CLASS
class fifo_transaction extends uvm_sequence_item;

    rand logic [7:0] data_in;                                            // Randomized input data
    rand logic rd_en;                                                    // Read enable flag
    rand logic wr_en;                                                    // Write enable flag
  
    function new(string name = "fifo_transaction");                      // Constructor
        super.new(name);
    endfunction

    `uvm_object_utils_begin(fifo_transaction)                            // Function to display transaction information
        `uvm_field_int(data_in, UVM_ALL_ON)
        `uvm_field_int(rd_en, UVM_ALL_ON)
        `uvm_field_int(wr_en, UVM_ALL_ON)
    `uvm_object_utils_end

endclass
