`timescale 1ns/1ps

module data_mem_tb;

    reg clk, we;
    reg [31:0] address, write_data;
    wire [31:0] read_data;
    integer errors = 0;

    data_mem dut(.clk(clk), .we(we), .address(address),
            .write_data(write_data), .read_data(read_data));

    always #5 clk = ~clk;

    initial begin
        clk = 0; we = 0; address = 0; write_data = 0;

        address = 0; #1;
        if (read_data !== 32'h12345678)
            begin $display("FAIL init_mem0"); errors = errors + 1; end
        else $display("PASS init_mem0");

        address = 2; #1;
        if (read_data !== 32'hDEADBEEF)
            begin $display("FAIL init_mem2"); errors = errors + 1; end
        else $display("PASS init_mem2");

        address = 10; write_data = 32'hCAFEBABE; we = 1;
        @(posedge clk); #1;
        we = 0;
        if (read_data !== 32'hCAFEBABE)
            begin $display("FAIL write_read"); errors = errors + 1; end
        else $display("PASS write_read");

        address = 300; #1;
        if (read_data !== 32'h0)
            begin $display("FAIL out_of_range"); errors = errors + 1; end
        else $display("PASS out_of_range");

        $display("errors: %0d", errors);
        $finish;
    end

endmodule