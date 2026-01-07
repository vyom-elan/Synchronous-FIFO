interface synchronous_fifo();
  logic clk, rst_n, w_en, r_en, empty, full;
  logic [1:0] data_in, data_out;                                                            //interface declaration for all the ports
  modport dt(input clk, rst_n, w_en, r_en, data_in, output data_out, full, empty);
  modport tb(output clk, rst_n, w_en, r_en, data_in, input data_out, full, empty);
endinterface
module fifo (synchronous_fifo.dt intf);  
  reg [2:0] w_ptr, r_ptr;
  reg [7:0] fifo[8];
  reg [2:0] count;
  always@(posedge intf.clk) begin
    if(!intf.rst_n) begin
      w_ptr <= 0; r_ptr <= 0;              //setting default value for reset condition
      intf.data_out <= 0;
      count <= 0;
    end
    else begin
      case({intf.w_en, intf.r_en})
        2'b00, 2'b11: count <= count;
        2'b01: count <= count - 1'b1;
        2'b10: count <= count + 1'b1;
      endcase
    end
  end
  always@(posedge intf.clk) begin
    if(intf.w_en & !intf.full)begin          //for write operation
      fifo[w_ptr] <= intf.data_in;
      w_ptr <= w_ptr + 1;
    end
  end
  always@(posedge intf.clk) begin
    if(intf.r_en & !intf.empty) begin      //for read operation
      intf.data_out <= fifo[r_ptr];
      r_ptr <= r_ptr + 1;
    end
  end
  assign intf.full = (count == 8);
  assign intf.empty = (count == 0);
endmodule
