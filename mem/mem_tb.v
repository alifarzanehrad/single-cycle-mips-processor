`timescale 1ns/1ps

module mem_tb;

    reg clk;
    reg we;
    reg [31:0] address;
    reg [31:0] write_data;
    wire [31:0] read_data;
    
    mem uut (
        .clk(clk),
        .we(we),
        .address(address),
        .write_data(write_data),
        .read_data(read_data)
    );
    
    always #5 clk = ~clk;
    
    initial begin
        clk = 0;
        we = 0;
        address = 0;
        write_data = 0;
        
        $display("==========================================");
        $display("Data Memory Test");
        $display("==========================================");
        
        #10;
        address = 0;
        #10;
        $display("Read[0] = %h (Expected: 12345678) %s", read_data, 
                 (read_data === 32'h12345678) ? "PASS" : "FAIL");
        
        #10;
        address = 1;
        #10;
        $display("Read[1] = %h (Expected: AABBCCDD) %s", read_data, 
                 (read_data === 32'hAABBCCDD) ? "PASS" : "FAIL");
        
        #10;
        address = 2;
        #10;
        $display("Read[2] = %h (Expected: DEADBEEF) %s", read_data, 
                 (read_data === 32'hDEADBEEF) ? "PASS" : "FAIL");
        
        #10;
        address = 5;
        write_data = 32'h11223344;
        we = 1;
        #10;
        $display("Write[5] = 11223344");
        
        #10;
        address = 5;
        we = 0;
        #10;
        $display("Read[5] = %h (Expected: 11223344) %s", read_data, 
                 (read_data === 32'h11223344) ? "PASS" : "FAIL");
        
        #10;
        address = 10;
        write_data = 32'h55667788;
        we = 1;
        #10;
        $display("Write[10] = 55667788");
        
        #10;
        address = 10;
        we = 0;
        #10;
        $display("Read[10] = %h (Expected: 55667788) %s", read_data, 
                 (read_data === 32'h55667788) ? "PASS" : "FAIL");
        
        #10;
        address = 0;
        we = 0;
        #10;
        $display("Read[0] = %h (Expected: 12345678) %s", read_data, 
                 (read_data === 32'h12345678) ? "PASS" : "FAIL");
        
        #10;
        address = 145;
        write_data = 32'h99AABBCC;
        we = 1;
        #10;
        $display("Write[145] = 99AABBCC");
        
        #10;
        address = 145;
        we = 0;
        #10;
        $display("Read[145] = %h (Expected: 99AABBCC) %s", read_data, 
                 (read_data === 32'h99AABBCC) ? "PASS" : "FAIL");
        
        #10;
        address = 300;
        we = 0;
        #10;
        $display("Read[300] = %h (Expected: 00000000) %s", read_data, 
                 (read_data === 32'h00000000) ? "PASS" : "FAIL");
        
        #10;
        address = 300;
        write_data = 32'hFFFFFFFF;
        we = 1;
        #10;
        $display("Write[300] = FFFFFFFF (Invalid address - should be ignored)");
        
        #10;
        address = 145;
        we = 0;
        #10;
        $display("Read[145] = %h (Expected: 99AABBCC) %s", read_data, 
                 (read_data === 32'h99AABBCC) ? "PASS" : "FAIL");
        
        $display("==========================================");
        $display("All tests completed!");
        
        #20;
        $finish;
    end
    
    initial begin
        $dumpfile("mem_tb.vcd");
        $dumpvars(0, mem_tb);
    end

endmodule