module mem_array(dout,din,clk,fwe,wptr,rptr);
	input[7:0] din;
	input clk,fwe;
	input[4:0]wptr, rptr;
	output[7:0] dout;
	reg[7:0] dout2[15:0];
	wire[7:0] dout;
	always2@(posedge clk)
	begin
		if(fwe)
			dout2[wptr[3:0]]<=din;
	end
	assign dout = dout2[rptr[3:0]];
endmodule
