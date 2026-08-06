`timescale 1ns/1ps

module alu_tb;
    reg  [31:0] in1, in2;
    reg  [2:0]  func;
    reg  [4:0]  shamt;
    wire [31:0] out;
    wire sign, overflow, zero;
    integer errors = 0;

    alu dut(.in1(in1), .in2(in2), .func(func), .shamt(shamt),
            .out(out), .sign(sign), .overflow(overflow), .zero(zero));

    task check(input [31:0] exp, input [63:0] name);
        begin
            #1;
            if (out !== exp) begin
                $display("FAIL %0s: out=%h expected=%h", name, out, exp);
                errors = errors + 1;
            end else
                $display("PASS %0s", name);
        end
    endtask

    initial begin
        shamt = 0;

        in1 = 10; in2 = 5;  func = 3'b000; check(15, "add");
        in1 = 5;  in2 = 10; func = 3'b001; check(-32'd5, "sub_negative");

        in1 = 32'h7FFFFFFF; in2 = 1; func = 3'b000; #1;
        if (!overflow) begin $display("FAIL add_overflow"); errors = errors + 1; end
        else $display("PASS add_overflow");

        in1 = 32'hFF00FF00; in2 = 32'h0F0F0F0F; func = 3'b010; check(32'hFF00FF00 & 32'h0F0F0F0F, "and");
        in1 = 32'hFF00FF00; in2 = 32'h0F0F0F0F; func = 3'b011; check(32'hFF00FF00 | 32'h0F0F0F0F, "or");
        in1 = 32'hFF00FF00; in2 = 32'h0F0F0F0F; func = 3'b100; check(32'hFF00FF00 ^ 32'h0F0F0F0F, "xor");

        shamt = 2; in1 = 32'h10; func = 3'b101; check(32'h40, "sll");
        shamt = 2; in1 = 32'h10; func = 3'b110; check(32'h04, "srl");

        in1 = 3; in2 = 7; func = 3'b111; check(1, "slt_true");
        in1 = 7; in2 = 3; func = 3'b111; check(0, "slt_false");

        in1 = 0; in2 = 0; func = 3'b000; #1;
        if (!zero) begin $display("FAIL zero_flag"); errors = errors + 1; end
        else $display("PASS zero_flag");

        $display("errors: %0d", errors);
        $finish;
    end
endmodule