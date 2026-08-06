`timescale 1ns/1ps

module registers_tb;

    reg clk, clr, regWrite;
    reg [4:0] readReg1, readReg2, writeReg;
    reg [31:0] writeData;
    wire [31:0] readData1, readData2;
    integer errors = 0;

    registers dut(.clk(clk), .clr(clr), .regWrite(regWrite),
                  .readReg1(readReg1), .readReg2(readReg2), .writeReg(writeReg),
                  .writeData(writeData), .readData1(readData1), .readData2(readData2));

    always #5 clk = ~clk;

    initial begin
        clk = 0; clr = 1; regWrite = 0;
        readReg1 = 0; readReg2 = 0; writeReg = 0; writeData = 0;

        @(posedge clk); #1;
        clr = 0;

        regWrite = 1; writeReg = 5; writeData = 32'hDEADBEEF;
        @(posedge clk); #1;
        regWrite = 0;

        readReg1 = 5; #1;
        if (readData1 !== 32'hDEADBEEF)
            begin $display("FAIL write_read"); errors = errors + 1; end
        else $display("PASS write_read");

        clr = 1; #1;
        if (readData1 !== 32'h0)
            begin $display("FAIL clear"); errors = errors + 1; end
        else $display("PASS clear");
        clr = 0;

        regWrite = 1; writeReg = 1; writeData = 32'h11111111;
        @(posedge clk); #1; regWrite = 0;
        regWrite = 1; writeReg = 2; writeData = 32'h22222222;
        @(posedge clk); #1; regWrite = 0;

        readReg1 = 1; readReg2 = 2; #1;
        if (readData1 !== 32'h11111111 || readData2 !== 32'h22222222)
            begin $display("FAIL dual_read"); errors = errors + 1; end
        else $display("PASS dual_read");

        $display("errors: %0d", errors);
        $finish;
    end

endmodule