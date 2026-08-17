`timescale 1ns/1ps
module alu_control_tb;
    reg [1:0] alu_op; reg [5:0] opcode, funct; wire [3:0] alu_func;
    integer errors=0;
    alu_control dut(.alu_op(alu_op),.opcode(opcode),.funct(funct),.alu_func(alu_func));
    task check; input [3:0] expected; begin #1; if(alu_func!==expected) errors=errors+1; end endtask
    initial begin
        alu_op=2'b00; opcode=6'h23; funct=0; check(0);
        alu_op=2'b01; check(1);
        alu_op=2'b10; funct=6'h2a; check(7); funct=6'h27; check(8);
        funct=6'h03; check(9); funct=6'h2b; check(10);
        alu_op=2'b11; opcode=6'h0c; check(2); opcode=6'h0d; check(3);
        opcode=6'h0e; check(4); opcode=6'h0a; check(7); opcode=6'h08; check(0);
        $display("alu_control_tb errors: %0d",errors); $finish;
    end
endmodule
