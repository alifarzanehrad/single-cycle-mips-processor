`timescale 1ns/1ps

module fib_tb;

    reg  clk, reset;
    wire [31:0] pc_out, instruction_out, alu_result_out, read_data_out;

    top uut (
        .clk(clk), .reset(reset),
        .pc_out(pc_out), .instruction_out(instruction_out),
        .alu_result_out(alu_result_out), .read_data_out(read_data_out)
    );

    always #5 clk = ~clk;
    integer i;

    initial begin
        clk = 0; reset = 0;
        #3 reset = 1;

        // enough cycles for 6 preamble + 8 loop iterations * 7 instructions + margin
        for (i = 0; i < 70; i = i + 1) begin
            @(posedge clk); #1;
        end

        $display("fibonacci sequence (mem[10..17]):");
        for (i = 10; i < 18; i = i + 1)
            $display("F = %0d", uut.data_mem_inst.mem[i]);

        $finish;
    end

endmodule