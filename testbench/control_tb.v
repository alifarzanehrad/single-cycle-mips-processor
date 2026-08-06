`timescale 1ns/1ps

module control_tb;

    reg [5:0] opcode;
    wire reg_dst, alu_src, mem_to_reg, reg_write, mem_read, mem_write, branch, jump;
    wire [1:0] alu_op;
    integer errors = 0;

    control dut(.opcode(opcode), .reg_dst(reg_dst), .alu_src(alu_src),
                .mem_to_reg(mem_to_reg), .reg_write(reg_write),
                .mem_read(mem_read), .mem_write(mem_write),
                .branch(branch), .alu_op(alu_op), .jump(jump));

    initial begin
        opcode = 6'b000000; #1; // r-type
        if (reg_dst !== 1 || reg_write !== 1 || alu_op !== 2'b10 || mem_write !== 0 || branch !== 0)
            begin $display("FAIL r_type"); errors = errors + 1; end
        else $display("PASS r_type");

        opcode = 6'b100011; #1; // lw
        if (alu_src !== 1 || mem_to_reg !== 1 || reg_write !== 1 || mem_read !== 1)
            begin $display("FAIL lw"); errors = errors + 1; end
        else $display("PASS lw");

        opcode = 6'b101011; #1; // sw
        if (alu_src !== 1 || mem_write !== 1 || reg_write !== 0)
            begin $display("FAIL sw"); errors = errors + 1; end
        else $display("PASS sw");

        opcode = 6'b000100; #1; // beq
        if (branch !== 1 || alu_op !== 2'b01 || reg_write !== 0)
            begin $display("FAIL beq"); errors = errors + 1; end
        else $display("PASS beq");

        opcode = 6'b000010; #1; // j
        if (jump !== 1 || reg_write !== 0 || branch !== 0)
            begin $display("FAIL jump"); errors = errors + 1; end
        else $display("PASS jump");

        opcode = 6'b111111; #1; // undefined opcode, all outputs must default to 0
        if (reg_write !== 0 || mem_write !== 0 || branch !== 0 || jump !== 0)
            begin $display("FAIL undefined_opcode"); errors = errors + 1; end
        else $display("PASS undefined_opcode");

        $display("errors: %0d", errors);
        $finish;
    end

endmodule