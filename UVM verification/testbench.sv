module testbench;

    fifo_intf intf();                               // Instantiate the FIFO interface

    logic       clk;
    logic       rst;

    covergroup intf_coverage @(posedge clk);
        option.per_instance = 1;
        coverpoint intf.wr_en 
        {
            bins write = {1};
            bins no_write = {0};
        }
        coverpoint intf.rd_en 
        {
            bins read = {1};
            bins no_read = {0};
        }
    endgroup : intf_coverage

    intf_coverage cg_inst ;
    test cg_test;

    fifo fifo (
    .clk(intf.clk),
    .rst(intf.rst),
    .wr_en(intf.wr_en),
    .rd_en(intf.rd_en),
    .full(intf.full),
    .empty(intf.empty),
    .data_in(intf.data_in),
    .data_out(intf.data_out)
  );
  
    always @(posedge intf.clk) begin
        cg_inst.sample();                    // Assuming cg_inst is the covergroup instance
    end

    initial begin
        uvm_config_db #(virtual fifo_intf)::set(null, "*", "fifo_intf", intf);
        run_test("test_2");
    end

    initial begin                           // initialize and generate clock and reset
        cg_inst = new();
        cg_test = new(intf);
        intf.clk = 0;
        intf.rst = 1;
        #10 intf.rst = 0;
        $display("Simulation started");
        #1000
        $finish;
    end

    always begin
        #5
        intf.clk = ~intf.clk;
        cg_test.sample();
        $display("Coverage = %0.2f %%", cg_inst.get_inst_coverage());
        $display("Coverage test = %0.2f %%", cg_test.get_inst_coverage());
    end
    
endmodule
