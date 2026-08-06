`timescale 1ns/1ps

module alu_control_tb;

    reg  [1:0] alu_op;
    reg  [5:0] funct;
    wire [2:0] alu_func;
    integer errors = 0;

    alu_control dut(.alu_op(alu_op), .funct(funct), .alu_func(alu_func));

    task check(input [2:0] exp, input [63:0] name);
        begin
            #1;
            if (alu_func !== exp) begin
                $display("FAIL %0s: got=%b expected=%b", name, alu_func, exp);
                errors = errors + 1;
            end else
                $display("PASS %0s", name);
        end
    endtask

    initial begin
        alu_op = 2'b00; funct = 6'bxxxxxx; check(3'b000, "lw_sw_add");
        alu_op = 2'b01; funct = 6'bxxxxxx; check(3'b001, "beq_sub");

        alu_op = 2'b10; funct = 6'b100000; check(3'b000, "r_add");
        alu_op = 2'b10; funct = 6'b100010; check(3'b001, "r_sub");
        alu_op = 2'b10; funct = 6'b100100; check(3'b010, "r_and");
        alu_op = 2'b10; funct = 6'b101010; check(3'b100, "r_slt");
        alu_op = 2'b10; funct = 6'b111111; check(3'b000, "r_unknown_default");

        $display("errors: %0d", errors);
        $finish;
    end

endmodule