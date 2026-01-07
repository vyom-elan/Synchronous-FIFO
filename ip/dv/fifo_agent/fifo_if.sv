

interface fifo_if (
  input logic clk_i,
  input logic rst_ni
);

  // Width and Depth Parameters
  parameter int FifoWidth = 16;
  parameter int FifoDepth = 8;

  // DUT Signals (from your reference FIFO_IF.sv)
  // I am using the _i and _o convention for clarity
  logic [FifoWidth-1:0] data_in;
  logic                 wr_en;
  logic                 rd_en;
  logic [FifoWidth-1:0] data_out;
  logic                 wr_ack;
  logic                 overflow;
  logic                 full;
  logic                 empty;
  logic                 almostfull;
  logic                 almostempty;
  logic                 underflow;

  // Clocking block for the UVM Driver (drives inputs)
  clocking drv_cb @(posedge clk_i);
    default input #1step output #1;
    output data_in;
    output wr_en;
    output rd_en;
  endclocking
  
  // Clocking block for the UVM Monitor (samples all signals)
  clocking mon_cb @(posedge clk_i);
    default input #1step;
    input data_in;
    input wr_en;
    input rd_en;
    input data_out;
    input wr_ack;
    input overflow;
    input full;
    input empty;
    input almostfull;
    input almostempty;
    input underflow;
  endclocking

  // Modport for the dut (Design Under Test) side
  // Note the signal directions are from the DUT's perspective
  modport dut (
    input  clk_i,
    input  rst_ni,
    input  data_in,
    input  wr_en,
    input  rd_en,
    output data_out,
    output wr_ack,
    output overflow,
    output full,
    output empty,
    output almostfull,
    output almostempty,
    output underflow
  );

endinterface