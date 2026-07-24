`timescale 1ns/1ps

module tb_ALU();

    reg  [31:0] in1;
    reg  [31:0] in2;
    reg  [2:0]  func;
    reg  [4:0]  shamt;
    wire [31:0] out;
    wire        sign;
    wire        overflow;
    wire        zero;

    ALU uut (
        .in1(in1),
        .in2(in2),
        .func(func),
        .shamt(shamt),
        .out(out),
        .sign(sign),
        .overflow(overflow),
        .zero(zero)
    );

    initial begin
        $dumpfile("alu_test.vcd");
        $dumpvars(0, tb_ALU);

        $monitor("Time=%0t | func=%b | in1=%d | in2=%d | out=%d | zero=%b | ovf=%b", 
                 $time, func, in1, in2, out, zero, overflow);

        func = 3'b000; in1 = 32'd10; in2 = 32'd20; shamt = 5'd0;
        #10;

        func = 3'b001; in1 = 32'd50; in2 = 32'd20;
        #10;

        func = 3'b010; in1 = 32'd16; shamt = 5'd2;
        #10;

        func = 3'b011; in1 = 32'd3; shamt = 5'd3;
        #10;

        func = 3'b100; in1 = 32'hFFFF_0000; in2 = 32'h00FF_00FF;
        #10;

        func = 3'b101; in1 = 32'd15; in2 = 32'd40;
        #10;

        func = 3'b110; in1 = 32'd100; in2 = 32'd45;
        #10;

        func = 3'b001; in1 = 32'd25; in2 = 32'd25;
        #10;

        func = 3'b000; in1 = 32'h7FFF_FFFF; in2 = 32'd1;
        #10;

        $finish;
    end

endmodule