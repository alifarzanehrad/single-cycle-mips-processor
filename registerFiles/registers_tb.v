`timescale 1ns/1ps

module registers_tb;

    reg         clk;
    reg         clr;
    reg         regWrite;
    reg  [4:0]  readReg1;
    reg  [4:0]  readReg2;
    reg  [4:0]  writeReg;
    reg  [31:0] writeData;
    wire [31:0] readData1;
    wire [31:0] readData2;

    registers uut (
        .clk        (clk),
        .clr        (clr),
        .regWrite   (regWrite),
        .readReg1   (readReg1),
        .readReg2   (readReg2),
        .writeReg   (writeReg),
        .writeData  (writeData),
        .readData1  (readData1),
        .readData2  (readData2)
    );

    always #5 clk = ~clk;

    initial begin
        
        clk = 0;
        clr = 0;
        regWrite = 0;
        readReg1 = 0;
        readReg2 = 0;
        writeReg = 0;
        writeData = 0;

        $display("1. Reset");
        clr = 1;
        #10;
        clr = 0;
        #10;
        readReg1 = 5;
        #5;
        $display("   reg[5] = %h (should be 0)\n", readData1);

        $display("2. Write and Read");
        @(posedge clk);
        regWrite = 1;
        writeReg = 3;
        writeData = 32'h12345678;
        @(posedge clk);
        regWrite = 0;
        
        readReg1 = 3;
        #5;
        $display("   reg[3] = %h (should be 12345678)\n", readData1);

        $display("3. Write multiple registers");
        @(posedge clk);
        regWrite = 1;
        writeReg = 7;
        writeData = 32'hAAAA5555;
        @(posedge clk);
        writeReg = 10;
        writeData = 32'hDEADBEEF;
        @(posedge clk);
        regWrite = 0;
        
        readReg1 = 7;
        readReg2 = 10;
        #5;
        $display("   reg[7]  = %h", readData1);
        $display("   reg[10] = %h\n", readData2);

        $display("4. Overwrite");
        @(posedge clk);
        regWrite = 1;
        writeReg = 3;
        writeData = 32'hFFFFFFFF;
        @(posedge clk);
        regWrite = 0;
        
        readReg1 = 3;
        #5;
        $display("   reg[3] = %h (should be FFFFFFFF)\n", readData1);

        $display("5. Reset again");
        clr = 1;
        #10;
        clr = 0;
        #10;
        readReg1 = 3;
        readReg2 = 7;
        #5;
        $display("   reg[3] = %h (should be 0)", readData1);
        $display("   reg[7] = %h (should be 0)\n", readData2);

        $display("6. Write all registers with pattern");
        for (integer i = 0; i < 32; i = i + 1) begin
            @(posedge clk);
            regWrite = 1;
            writeReg = i;
            writeData = i;
        end
        @(posedge clk);
        regWrite = 0;
        
        $display("   Reading all registers:");
        for (integer i = 0; i < 32; i = i + 1) begin
            readReg1 = i;
            #5;
            if (readData1 == i)
                $display("   reg[%2d] = %h ✓", i, readData1);
            else
                $display("   reg[%2d] = %h ✗ (should be %h)", i, readData1, i);
        end

        #50;
        $finish;
    end

    initial begin
        $dumpfile("registers.vcd");
        $dumpvars(0, registers_tb);
    end

endmodule