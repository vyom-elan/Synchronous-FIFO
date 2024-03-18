module fifo_top #(parameter DEPTH = 63, WIDTH = 8)(
    input                    clk,
    input                    rst,
    output logic [WIDTH-1:0] data_out
    );

    logic [WIDTH-1:0] data_in;
    logic             rd_en;
    logic             wr_en;
    logic             full;
    logic             empty;

    data_gen #(
        .WIDTH(8),
        .DEPTH(63)
        ) gen(                              // Instantiates of modules
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .data_out(data_in)
        );
      
    fifo #(
        .WIDTH(8),
        .DEPTH(63)
        ) dut(                              //instantiate the module fpga
        .clk(clk),
        .rst(rst),
        .rd_en(rd_en),
        .wr_en(wr_en),
        .data_in(data_in),
        .full(full),
        .empty(empty),
        .data_out(data_out)
        );
        
endmodule
