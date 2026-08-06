`timescale 1ns/1ps

module pc_tb;

    reg clk, reset, jump, branch;
    reg [25:0] jump_address;
    reg [15:0] branch_offset;
    wire [31:0] pc;
    integer errors = 0;

    pc_calculator dut(.clk(clk), .reset(reset), .jump(jump), .branch(branch),
                       .jump_address(jump_address), .branch_offset(branch_offset), .pc(pc));

    always #5 clk = ~clk;

    initial begin
        clk = 0; reset = 0; jump = 0; branch = 0;
        jump_address = 0; branch_offset = 0;

        #1;
        if (pc !== 32'h0)
            begin $display("FAIL async_reset"); errors = errors + 1; end
        else $display("PASS async_reset");

        reset = 1;

        @(posedge clk); #1;
        if (pc !== 32'd4)
            begin $display("FAIL pc_plus4_first"); errors = errors + 1; end
        else $display("PASS pc_plus4_first");

        @(posedge clk); #1;
        if (pc !== 32'd8)
            begin $display("FAIL pc_plus4_second"); errors = errors + 1; end
        else $display("PASS pc_plus4_second");

        branch = 1; branch_offset = 16'd2;
        @(posedge clk); #1;
        branch = 0;
        if (pc !== 32'd20)
            begin $display("FAIL branch_target"); errors = errors + 1; end
        else $display("PASS branch_target");

        jump = 1; jump_address = 26'd100;
        @(posedge clk); #1;
        jump = 0;
        if (pc[27:0] !== {26'd100, 2'b00})
            begin $display("FAIL jump_target"); errors = errors + 1; end
        else $display("PASS jump_target");

        reset = 0; #1;
        if (pc !== 32'h0)
            begin $display("FAIL mid_run_reset"); errors = errors + 1; end
        else $display("PASS mid_run_reset");

        $display("errors: %0d", errors);
        $finish;
    end

endmodule