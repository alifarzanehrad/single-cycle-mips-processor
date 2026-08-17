`timescale 1ns/1ps
module alu_tb;
    reg [31:0] in1, in2; reg [3:0] func; reg [4:0] shamt;
    wire [31:0] out; wire sign, overflow, zero;
    integer errors=0;
    alu dut(.in1(in1),.in2(in2),.func(func),.shamt(shamt),
        .out(out),.sign(sign),.overflow(overflow),.zero(zero));
    task check; input [31:0] expected; begin #1;
        if (out !== expected) begin $display("FAIL func=%h got=%h expected=%h",func,out,expected); errors=errors+1; end
    end endtask
    initial begin
        in1=32'd7; in2=32'd3; shamt=0; func=0; check(10);
        func=1; check(4); func=2; check(3); func=3; check(7); func=4; check(4);
        in2=32'd3; shamt=2; func=5; check(12); func=6; check(0);
        in1=-2; in2=1; func=7; check(1); func=10; check(0);
        in1=32'h0f0f; in2=32'h00ff; func=8; check(~(32'h0f0f|32'h00ff));
        in2=-8; shamt=2; func=9; check(32'hfffffffe);
        $display("alu_tb errors: %0d",errors); $finish;
    end
endmodule
