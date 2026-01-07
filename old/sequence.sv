// SEQUENCE
class fifo_test_1_sequence extends uvm_sequence #(fifo_transaction);

    `uvm_object_utils(fifo_test_1_sequence)
    fifo_transaction trans;                                               // Transaction object

    function new(string name = "fifo_seq_1");
        super.new(name);
    endfunction

    task body();                                                          // Sequence body

        for (int i = 0; i < 40; i++) begin

            $display("Inside fifo_test_1_sequence");

            trans = fifo_transaction::type_id::create("tx_fifo_trans");
            start_item(trans);

            $display("Inside fifo_test_1_sequence starting item");

            if (i < 20) begin
                if (!trans.randomize() with {trans.rd_en == 1'b1; trans.wr_en == 1'b0;}) begin
                    `uvm_error("Sequence", "Randomization failure for trasaction")
                end
            end

            else begin
                if (!trans.randomize() with {trans.rd_en == 1'b0; trans.wr_en == 1'b1;}) begin
                    `uvm_error("Sequence", "Randomization failure for trasaction")
                end
            end
            finish_item(trans);
        end
    endtask
endclass : fifo_test_1_sequence


class fifo_test_2_sequence extends uvm_sequence #(fifo_transaction);

    `uvm_object_utils(fifo_test_2_sequence)
    fifo_transaction trans;                                             // transaction class

    function new(string name = "fifo_seq_2");
        super.new(name);
    endfunction

    task body();                                                        // Sequence body

        for (int i = 0; i < 64; i++) begin

            $display("Inside fifo_test_2_sequence");

            trans = fifo_transaction::type_id::create("tx_fifo_trans");
            start_item(trans);

            $display("Inside fifo_test_2_sequence starting item");

            if (i < 8) begin
                if (!trans.randomize() with {trans.rd_en == 1'b1; trans.wr_en == 1'b0;}) begin
                    `uvm_error("Sequence", "Randomization failure for trasaction")
                end
            end

            else begin
                if (!trans.randomize() with {trans.rd_en == 1'b1; trans.wr_en == 1'b1;}) begin
                    `uvm_error("Sequence", "Randomization failure for trasaction")
                end
            end
            finish_item(trans);
        end
    endtask
endclass : fifo_test_2_sequence

//------------------------------------------------------------------------------------------
