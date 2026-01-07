
module fifo #(
  parameter int FIFO_WIDTH = 16,
  parameter int FIFO_DEPTH = 8
) (

  input logic clk_i,
  input logic rst_ni,
  fifo_if.dut fifoif
);

logic [FIFO_WIDTH-1:0] data_in;
logic wr_en, rd_en;
logic [FIFO_WIDTH-1:0] data_out;
logic wr_ack, overflow;
logic full, empty, almostfull, almostempty, underflow;

assign data_in = fifoif.data_in;
assign wr_en = fifoif.wr_en;
assign rd_en = fifoif.rd_en;
assign fifoif.data_out = data_out;
assign fifoif.wr_ack = wr_ack;
assign fifoif.overflow = overflow;
assign fifoif.full = full;
assign fifoif.empty = empty;
assign fifoif.almostfull = almostfull;
assign fifoif.almostempty = almostempty;
assign fifoif.underflow = underflow;

localparam max_fifo_addr = $clog2(FIFO_DEPTH);
reg [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];
reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;

  always_comb begin
    if(!rst_ni) begin
      `ifdef SIM
        count_aa: assert final(count == 0);
        wr_ptr_aa: assert final(wr_ptr == 0);
        rd_ptr_aa: assert final(rd_ptr == 0);
        full_aa: assert final(full == 0);
        empty_aa: assert final(empty == 1);
        underflow_aa: assert final(underflow == 0);
        almostfull_aa: assert final(almostfull == 0);
        almostempty_aa: assert final(almostempty == 0);
        wr_ack_aa: assert final(wr_ack == 0);
        overflow_aa: assert final(overflow == 0);
      `endif
    end

    if((count == FIFO_DEPTH)) begin
      `ifdef SIM
        full_a: assert final(full == 1);
      `endif
    end
    if((count == 0)) begin
      `ifdef SIM
        empty_a: assert final(empty == 1);
      `endif
    end
    if((count == FIFO_DEPTH - 1)) begin
      `ifdef SIM
        almostfull_a: assert final(almostfull == 1);
      `endif
    end
    if((count == 1)) begin
      `ifdef SIM
        almostempty_a: assert final(almostempty == 1);
      `endif
    end
  end

property ack_p;
	@(posedge clk_i) disable iff (rst_ni == 0) wr_en && (count < FIFO_DEPTH) |=> wr_ack ;
endproperty

property overflow_p;
	@(posedge clk_i) disable iff (rst_ni == 0) ((count == FIFO_DEPTH) && wr_en) |=> (overflow == 1);
endproperty

property underflow_p;
	@(posedge clk_i) disable iff (rst_ni == 0) (empty) && (rd_en) |=> underflow;
endproperty 

property wr_ptr_p;
	@(posedge clk_i) disable iff (rst_ni == 0) (wr_en) && (count < FIFO_DEPTH) |=> (wr_ptr == $past(wr_ptr) + 1'b1);
endproperty

property rd_ptr_p;
	@(posedge clk_i) disable iff (rst_ni == 0) (rd_en) && (count != 0) |=> (rd_ptr == $past(rd_ptr) + 1'b1);
endproperty

property count_write_priority_p;
	@(posedge clk_i) disable iff (rst_ni == 0) (wr_en) && (rd_en) && (empty) |=> (count == $past(count) + 1);
endproperty

property count_read_priority_p;
	@(posedge clk_i) disable iff (rst_ni == 0) (wr_en) && (rd_en) && (full) |=> (count == $past(count) - 1);
endproperty

property count_w_p;
	@(posedge clk_i) disable iff (rst_ni == 0) (wr_en) && (!rd_en) && (!full) |=> (count == $past(count) + 1);
endproperty

property count_r_p;
	@(posedge clk_i) disable iff (rst_ni == 0) (!wr_en) && (rd_en) && (!empty) |=> (count == $past(count) - 1);	
endproperty

  `ifdef SIM
    ack_a: assert property (ack_p);
    overflow_a: assert property (overflow_p);
    underflow_a: assert property (underflow_p);
    wr_ptr_a: assert property (wr_ptr_p);
    rd_ptr_a: assert property (rd_ptr_p);
    count_write_priority_a: assert property (count_write_priority_p);
    count_read_priority_a: assert property (count_read_priority_p);
    count_w_a: assert property (count_w_p);
    count_r_a: assert property (count_r_p);
  `endif

ack_c: cover property (ack_p);
overflow_c: cover property (overflow_p);
underflow_c: cover property (underflow_p);
wr_ptr_c: cover property (wr_ptr_p);
rd_ptr_c: cover property (rd_ptr_p);
count_write_priority_c: cover property (count_write_priority_p);
count_read_priority_c: cover property (count_read_priority_p);
count_w_c: cover property (count_w_p);
count_r_c: cover property (count_r_p);

always_comb begin
  if (!rst_ni) begin
    wr_ack = 0;
  end
  else if (wr_en && count < FIFO_DEPTH) begin
    wr_ack = 1; 
  end
  else begin
    wr_ack = 0;
  end
end

always @(posedge clk_i or negedge rst_ni) begin
	if (!rst_ni) begin
		wr_ptr <= 0;

		overflow <= 0; 
	end
	else if (wr_en && count < FIFO_DEPTH) begin
		mem[wr_ptr] <= data_in;
		wr_ptr <= wr_ptr + 1;
		overflow <= 0; 
	end
	else begin 
		if (full & wr_en)
			overflow <= 1;
		else
			overflow <= 0;
	end
end

always @(posedge clk_i or negedge rst_ni) begin
	if (!rst_ni) begin
		rd_ptr <= 0;
		underflow <= 0; 
	end
	else if (rd_en && count != 0) begin
		data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
		underflow <= 0; 
	end
	else begin
		if(empty && rd_en)
			underflow = 1;
		else 
			underflow = 0;
	end
end

always @(posedge clk_i or negedge rst_ni) begin
	if (!rst_ni) begin
		count <= 0;
	end
	else begin
		if (wr_en && rd_en && empty) 
			count <= count + 1;
		else if (wr_en && rd_en && full) 
			count <= count - 1; 
		else if ( ({wr_en, rd_en} == 2'b10) && !full) 
			count <= count + 1;
		else if ( ({wr_en, rd_en} == 2'b01) && !empty)
			count <= count - 1;
	end
end

assign full = (count == FIFO_DEPTH)? 1 : 0;  
assign empty = (count == 0)? 1 : 0;
assign almostfull = (count == FIFO_DEPTH-1)? 1 : 0; 
assign almostempty = (count == 1)? 1 : 0;

endmodule