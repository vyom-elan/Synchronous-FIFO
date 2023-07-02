module fmem(dout,ffull,fempty,fthreshold,foverflow,funderflow,rst,wr,rd,din);
	input wr,rd,clk,rst;
	input[7:0] din;
	output[7:0] dout;
	output ffull,fempty,fthreshold,foverflow,funderflow;
	wire[4:0] wptr,rptr;
	wire fwe,frd;
	write_pointer top1(wptr,fwe,wr,ffull,clk,rst);
	read_pointer top2(rptr,frd,rd,fempty,clk,rst);
	memory_array top3(dout,din,clk,fwe,wptr,rptr);
	status_signal top4(ffull,fempty,fthreshold,foverflow,funderflow,wr,rd,fwe,frd,wptr,rptr,clk,rst);
endmodule
