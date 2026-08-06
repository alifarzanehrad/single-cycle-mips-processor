`timescale 1ns/1ps

module top_tb;

    reg  clk, reset;
    wire [31:0] pc_out, instruction_out, alu_result_out, read_data_out;

    top uut (
        .clk(clk), .reset(reset),
        .pc_out(pc_out), .instruction_out(instruction_out),
        .alu_result_out(alu_result_out), .read_data_out(read_data_out)
    );

    always #5 clk = ~clk;

    // program in instrmem: lw, lw, add, sw, lw, beq(taken), poison, landing
    reg [31:0] exp_alu  [0:6];
    reg [31:0] exp_read [0:6];
    integer errors = 0;
    integer i;

    initial begin
        exp_alu[0] = 32'h00000000; exp_read[0] = 32'h12345678; // lw $1, 0($0)
        exp_alu[1] = 32'h00000001; exp_read[1] = 32'hAABBCCDD; // lw $2, 1($0)
        exp_alu[2] = 32'hBCF02355; exp_read[2] = 32'h00000000; // add $3, $1, $2
        exp_alu[3] = 32'h00000003; exp_read[3] = 32'h00000000; // sw  $3, 3($0)
        exp_alu[4] = 32'h00000003; exp_read[4] = 32'hBCF02355; // lw  $4, 3($0)
        exp_alu[5] = 32'h00000000; exp_read[5] = 32'h12345678; // beq $0, $0, 1
        exp_alu[6] = 32'hCF2479CD; exp_read[6] = 32'h00000000; // add $5, $4, $1
    end

    task check(input [31:0] got, input [31:0] exp, input [63:0] name);
        begin
            if (got !== exp) begin
                $display("FAIL %0s: got=%h expected=%h", name, got, exp);
                errors = errors + 1;
            end else
                $display("PASS %0s", name);
        end
    endtask

    initial begin
        clk = 0; reset = 0;
        #3 reset = 1;

        #1;
        $display("cycle 0: pc=%h inst=%h alu=%h read=%h",
                  pc_out, instruction_out, alu_result_out, read_data_out);
        check(alu_result_out, exp_alu[0], "cycle0_alu");
        check(read_data_out,  exp_read[0], "cycle0_read");

        for (i = 1; i < 50; i = i + 1) begin
            @(posedge clk); #1;
            $display("cycle %0d: pc=%h inst=%h alu=%h read=%h",
                      i, pc_out, instruction_out, alu_result_out, read_data_out);

            if (i <= 6) begin
                check(alu_result_out, exp_alu[i], "alu");
                check(read_data_out,  exp_read[i], "read");
                if (i == 6 && instruction_out == 32'hFFFFFFFF) begin
                    $display("FAIL poison_instruction_executed");
                    errors = errors + 1;
                end
            end
        end

        $display("total errors: %0d", errors);
        $finish;
    end

    initial begin
        $dumpfile("top.vcd");
        $dumpvars(0, top_tb);
    end

endmodule