module testbench(synchronous_fifo.tb intf);
  initial
    begin
      intf.clk = 0;
      intf.w_en = 0;
      intf.r_en = 0;
      intf.rst_n = 0;
      intf.data_in = 0;
    end
  always #2 intf.clk = ~intf.clk;
  covergroup c @(posedge intf.clk);
    option.per_instance = 1;
    coverpoint intf.empty 
    {
      bins empty_y = {1};
      bins empty_n = {1};
    }
    coverpoint intf.full 
    {
      bins full_y = {0};
      bins full_n = {0};
    }
    coverpoint intf.rst_n 
    {
      bins rst_y = {0};
      bins rst_n = {1};
    }
    coverpoint intf.w_en 
    {
      bins w_y = {0};
      bins w_n = {1};
    }
    coverpoint intf.r_en 
    {
      bins r_y = {0};
      bins r_n = {0};
    }
    coverpoint intf.data_in 
    {
      option.auto_bin_max = 256;
      bins low = {[0:127]};
      bins high = {[128:255]};
    }
    coverpoint intf.data_out 
    {
      option.auto_bin_max = 256;
      bins low = {[0:127]};
      bins high = {[128:255]};
    }
    cross_w_enXdata_in: cross intf.w_en, intf.data_in;	//cross coverage
    cross_r_enXdata_out: cross intf.r_en, intf.data_out;
  endgroup
  c ci; //covergroup instantiation
  task push();
    if(!intf.full) begin
      intf.w_en = 1'b1;
      intf.r_en = 1'b0;
      intf.data_in = $random;
      #1 $display("Push In: w_en=%b, r_en=%b, data_in=%h",intf.w_en, intf.r_en,intf.data_in);
    end
    else $display("FIFO Full!! Can not push data_in=%d", intf.data_in);
  endtask 
  
  task pop();
    if(!intf.empty) begin
      intf.r_en = 1'b1;
      intf.w_en = 1'b0;
      intf.data_out = $random;
      #1 
      $display("Pop Out: w_en=%b, r_en=%b, data_out=%h",intf.w_en, intf.r_en,intf.data_out);
    end
    else $display("FIFO Empty!! Can not pop data_out");
  endtask
  
  task drive(int delay);
    intf.w_en = 0; intf.r_en = 0;
    fork
      begin
        repeat(10) begin @(posedge intf.clk) push(); end
        intf.w_en = 0;
      end
      begin
        #delay;
        repeat(10) begin @(posedge intf.clk) pop(); end
        intf.r_en = 0;
      end
    join
  endtask
  
  initial
    begin
      intf.rst_n = 1'b1;
      #10;
      intf.rst_n = 0;
      intf.w_en = 0;
      intf.r_en = 0;
      #10;
      push();
      #10
      pop();
      #10;
    end 
  initial 
    begin
      ci = new();
      $display("---");
      $display("Coverage is %0f", ci.get_coverage());
      $display("---");
      $dumpfile("dump.vcd"); 
      $dumpvars;
      #200
      $finish();
  end
endmodule
module top_module();
  synchronous_fifo dtt();
  fifo dut(dtt);
  testbench test(dtt);
endmodule
