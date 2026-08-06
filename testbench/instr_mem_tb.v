`timescale 1ns/1ps

module instrmem_tb;

    reg  [31:0] address;
    wire [31:0] instruction;
    integer errors = 0;

    instr_mem dut(.address(address), .instruction(instruction));

    initial begin
        address = 0; #1;
        if (instruction !== 32'h8C010000)
            begin $display("FAIL instr_addr0"); errors = errors + 1; end
        else $display("PASS instr_addr0");

        address = 8; #1;
        if (instruction !== 32'h00221820)
            begin $display("FAIL instr_addr8"); errors = errors + 1; end
        else $display("PASS instr_addr8");

        $display("errors: %0d", errors);
        $finish;
    end

endmodule