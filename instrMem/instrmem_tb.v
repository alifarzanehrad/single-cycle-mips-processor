`timescale 1ns/1ps

module instrmem_tb;

    reg clk;
    reg [31:0] address;
    
    wire [31:0] instruction;
    
    instrmem uut (
        .clk(clk),
        .address(address),
        .instruction(instruction)
    );
    
    //(10ns period)
    always #5 clk = ~clk;
    
    initial begin
    
        clk = 0;
        address = 0;
        

        // Test 1: Address 0
        #10;
        address = 32'h00000000;
        #10;
        if (instruction === 32'h3412013C)
            $display("  1  |  %h  | %h | %h | PASSED", address, 32'h3412013C, instruction);
        else
            $display("  1  |  %h  | %h | %h | FAILED", address, 32'h3412013C, instruction);
        
        // Test 2: Address 4
        #10;
        address = 32'h00000004;
        #10;
        if (instruction === 32'h56782234)
            $display("  2  |  %h  | %h | %h | PASSED", address, 32'h56782234, instruction);
        else
            $display("  2  |  %h  | %h | %h | FAILED", address, 32'h56782234, instruction);
        
        // Test 3: Address 8
        #10;
        address = 32'h00000008;
        #10;
        if (instruction === 32'h000002AC)
            $display("  3  |  %h  | %h | %h | PASSED", address, 32'h000002AC, instruction);
        else
            $display("  3  |  %h  | %h | %h | FAILED", address, 32'h000002AC, instruction);
        
        // Test 4: Address 12
        #10;
        address = 32'h0000000C;
        #10;
        if (instruction === 32'h0000038C)
            $display("  4  |  %h  | %h | %h | PASSED", address, 32'h0000038C, instruction);
        else
            $display("  4  |  %h  | %h | %h | FAILED", address, 32'h0000038C, instruction);
        
        // Test 5: Address 16 (empty memory)
        #10;
        address = 32'h00000010;
        #10;
        if (instruction === 32'h00000000)
            $display("  5  |  %h  | %h | %h | PASSED", address, 32'h00000000, instruction);
        else
            $display("  5  |  %h  | %h | %h | FAILED", address, 32'h00000000, instruction);
        
        
        // Display all instructions in memory
        $display("\nAll instructions in memory:");
        
        #20;
        address = 32'h00000000;
        #10;
        $display("Address 0: %h", instruction);
        
        #20;
        address = 32'h00000004;
        #10;
        $display("Address 4: %h", instruction);
        
        #20;
        address = 32'h00000008;
        #10;
        $display("Address 8: %h", instruction);
        
        #20;
        address = 32'h0000000C;
        #10;
        $display("Address C: %h", instruction);
        
        #30;
        $finish;
    end
    
    initial begin
        $dumpfile("instrmem_tb.vcd");
        $dumpvars(0, instrmem_tb);
    end

endmodule