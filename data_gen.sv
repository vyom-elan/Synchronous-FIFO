module data_gen #(parameter DEPTH = 63, WIDTH = 8)(
    input                    clk,
    input                    rst,
    output logic             wr_en,
    output logic             rd_en,
    output logic [WIDTH-1:0] data_out
    );

    logic [WIDTH-1:0] counter;

    always @(posedge clk) begin
        if (rst) begin
            counter <= 0;
            wr_en   <= 0;
            rd_en   <= 0;
        end

        else if (counter < DEPTH+1) begin
            counter <= counter + 1;
            wr_en   <= 1;

        end

        else begin
            wr_en   <= 0;
            rd_en   <= ~wr_en;
            counter <= counter + 1;

        end  
    end

  assign data_out = counter <= DEPTH+1 ? counter : 0;

endmodule
