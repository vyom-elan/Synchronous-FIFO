module FIFO(clk,reset,put,get,data_in,empty_bar,full_bar,data_out);
  parameter DEPTH=8;
  parameter WIDTH=16;
  parameter POINTER_WIDTH=3;
  input clk;
  input reset;
  input put;
  input get;
  input [WIDTH-1:0]data_in;
  output empty_bar;
  output full_bar,
  output [WIDTH-1:0]data_out;
  reg [WIDTH-1:0]FIFO[DEPTH-1:0];
  reg[POINTER_WIDTH-1:0]wr_ptr;
  reg [POINTER_WIDTH-1:0] rd_ptr;
  reg empty_bar;
  reg full_bar;
  reg[WIDTH-1:0]data_out;
  reg[WIDTH-1:0]FIFO_3[DEPTH-1:0];
  wire [POINTER_WIDTH-1:0] wr_ptr_int;
  wire [POINTER_WIDTH-1:0] rd_ptr_int;
  wire full;
  wire empty;
  wire [POINTER_WIDTH:0] wr_rd;
  wire put_e;
  wire get_e;
  assign wr_rd=wr_ptr-rd_ptr;
  assign full=(wr_rd==4'b1000);
  assign empty=(wr_rd==4'b0000);
  assign put_e=(put&&full==1'b0);
  assign get_e=(get&&empty==1'b0);
  assign wr_ptr_int=wr_ptr[POINTER_WIDTH-1:0];
  assign rd_ptr_int=rd_ptr[POINTER_WIDTH-1:0];
  always@(posedge clk)
	begin
		if(reset)
			begin
				wr_ptr<=3'b000;
				rd_ptr<=3'b000;
			end 
		else
			begin
				if(put_e)
					begin
						FIFO_3[wr_ptr_int]<=data_in;
						wr_ptr<=wr_ptr+3'b001;
					end
				if(get_e)
					begin
						rd_ptr<=rd_ptr+3'b001;
					end
			end
	end
	always@(rd_ptr_int)
		begin
			data_out<=FIFO_3[rd_ptr_int-3'b001];
		end
	always@(empty or full)
		begin
			empty_bar<=~empty;
			full_bar<=~full;
		end	
endmodule	
