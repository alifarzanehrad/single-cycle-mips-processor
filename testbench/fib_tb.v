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

    // expected: first 20 Fibonacci numbers
    reg [31:0] expected [0:19];
    integer errors = 0;

    initial begin
        expected[0]=0;    expected[1]=1;    expected[2]=1;    expected[3]=2;
        expected[4]=3;    expected[5]=5;    expected[6]=8;    expected[7]=13;
        expected[8]=21;   expected[9]=34;   expected[10]=55;  expected[11]=89;
        expected[12]=144; expected[13]=233; expected[14]=377; expected[15]=610;
        expected[16]=987; expected[17]=1597;expected[18]=2584;expected[19]=4181;
    end

    initial begin
        clk = 0; reset = 0;
        #3 reset = 1;

        for (i = 0; i < 170; i = i + 1) begin
            @(posedge clk); #1;
        end

        $display("Fibonacci sequence (first 20 terms):");
        for (i = 0; i < 20; i = i + 1) begin
            $display("F(%0d) = %0d", i, uut.data_mem_inst.mem[10 + i]);
            if (uut.data_mem_inst.mem[10 + i] !== expected[i]) begin
                $display("  FAIL: expected %0d", expected[i]);
                errors = errors + 1;
            end
        end

        $display("errors: %0d", errors);
        $finish;
    end

endmodule