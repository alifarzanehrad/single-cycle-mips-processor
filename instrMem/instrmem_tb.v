`timescale 1ns/1ps

module instrmem_tb;

    reg         clk;
    reg  [9:0]  address;
    wire [31:0] instruction;
    integer i;  

    instrmem uut (
        .clk        (clk),
        .address    (address),
        .instruction(instruction)
    );

    always #5 clk = ~clk;

    initial begin
        $display("\n========== INSTRUCTION MEMORY TEST ==========\n");
        
        clk = 0;
        address = 0;
        
        for (i = 0; i < 8; i = i + 1) begin
            address = i * 4;
            #10;
            $display("Address %2d: 0x%h", address, instruction);
        end
        
        $display("\n========== TEST COMPLETED ==========");
        #50;
        $finish;
    end

    initial begin
        $dumpfile("instrmem.vcd");
        $dumpvars(0, instrmem_tb);
    end

endmodule