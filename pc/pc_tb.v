`timescale 1ns/1ps

module pc_calculator_tb;

    reg         clk;
    reg         reset;
    reg         jump;
    reg         branch;
    reg  [25:0] jump_address;
    reg  [15:0] branch_offset;
    wire [31:0] pc;

    pc_calculator uut (
        .clk            (clk),
        .reset          (reset),
        .jump           (jump),
        .branch         (branch),
        .jump_address   (jump_address),
        .branch_offset  (branch_offset),
        .pc             (pc)
    );

    always #5 clk = ~clk;

    integer i;
    reg [31:0] expected_pc;
    reg [31:0] pc_prev;

    initial begin        
        clk = 0;
        reset = 1;
        jump = 0;
        branch = 0;
        jump_address = 26'h0000000;
        branch_offset = 16'h0000;
        pc_prev = 0;
        
        $display("TEST 1: Reset (Active Low)");
        $display("----------------------------------------");
        reset = 0;
        #10;
        $display("  Reset=0 -> PC = 0x%08h (expected 0x00000000)", pc);
        if (pc === 32'h00000000)
            $display("PASSED\n");
        else
            $display("FAILED\n");
        
        reset = 1;
        @(posedge clk);
        #1;
        $display("  Reset=1 -> PC = 0x%08h", pc);
        #10;
        
        $display("TEST 2: Normal Mode (PC + 4)");
        $display("----------------------------------------");
        jump = 0;
        branch = 0;
        pc_prev = pc;
        
        for (i = 0; i < 4; i = i + 1) begin
            @(posedge clk);
            #1;
            expected_pc = pc_prev + 4;
            $display("  Cycle %d: PC = 0x%08h (expected 0x%08h)", 
                     i+1, pc, expected_pc);
            if (pc === expected_pc)
                $display("PASSED");
            else
                $display("FAILED");
            pc_prev = pc;
        end
        $display("");
        
        $display("TEST 3: Branch Forward (Jump=0, Branch=1)");
        $display("----------------------------------------");
        pc_prev = pc;
        jump = 0;
        branch = 1;
        branch_offset = 16'h0004;
        @(posedge clk);
        #1;
        expected_pc = pc_prev + 4 + (32'h00000004 << 2);
        $display("  BranchOffset=0x%04h (+%d)", branch_offset, $signed(branch_offset));
        $display("  PC = 0x%08h (expected 0x%08h)", pc, expected_pc);
        if (pc === expected_pc)
            $display("PASSED\n");
        else
            $display("FAILED\n");
        pc_prev = pc;
        
        $display("TEST 4: Branch Backward (Jump=0, Branch=1)");
        $display("----------------------------------------");
        pc_prev = pc;
        branch_offset = 16'hFFFC;
        @(posedge clk);
        #1;
        expected_pc = pc_prev + 4 + (32'hFFFFFFFC << 2);
        $display("  BranchOffset=0x%04h (%d)", branch_offset, $signed(branch_offset));
        $display("  PC = 0x%08h (expected 0x%08h)", pc, expected_pc);
        if (pc === expected_pc)
            $display("PASSED\n");
        else
            $display("FAILED\n");
        pc_prev = pc;
        
        $display("TEST 5: Jump (Jump=1, Branch=0)");
        $display("----------------------------------------");
        pc_prev = pc;
        jump = 1;
        branch = 0;
        jump_address = 26'h0040000;
        @(posedge clk);
        #1;
        expected_pc = {pc_prev[31:28], jump_address, 2'b00};
        $display("  JumpAddress=0x%06h", jump_address);
        $display("  PC = 0x%08h (expected 0x%08h)", pc, expected_pc);
        if (pc === expected_pc)
            $display("PASSED\n");
        else
            $display("FAILED\n");
        pc_prev = pc;
        
        $display("TEST 6: Jump with different address");
        $display("----------------------------------------");
        pc_prev = pc;
        jump_address = 26'h00FFFFF;
        @(posedge clk);
        #1;
        expected_pc = {pc_prev[31:28], jump_address, 2'b00};
        $display("  JumpAddress=0x%06h", jump_address);
        $display("  PC = 0x%08h (expected 0x%08h)", pc, expected_pc);
        if (pc === expected_pc)
            $display("PASSED\n");
        else
            $display("FAILED\n");
        pc_prev = pc;
        
        $display("TEST 7: Invalid State (Jump=1, Branch=1)");
        $display("----------------------------------------");
        jump = 1;
        branch = 1;
        @(posedge clk);
        #1;
        $display("  Jump=1, Branch=1 -> PC = 0x%08h (expected xxxxxxxx)", pc);
        if (pc === 32'hxxxxxxxx)
            $display("PASSED (Output is X)\n");
        else
            $display("FAILED\n");
        
        $display("TEST 8: Exit Invalid State -> Normal");
        $display("----------------------------------------");
        jump = 0;
        branch = 0;
        @(posedge clk);
        #1;
        $display("  Jump=0, Branch=0 -> PC = 0x%08h", pc);
        $display("PASSED\n");
        pc_prev = pc;
        
        $display("TEST 9: Reset Again");
        $display("----------------------------------------");
        reset = 0;
        #10;
        $display("  Reset=0 -> PC = 0x%08h (expected 0x00000000)", pc);
        if (pc === 32'h00000000)
            $display("PASSED\n");
        else
            $display("FAILED\n");
        
        reset = 1;
        @(posedge clk);
        #1;
        pc_prev = pc;
        #10;
        
        $display("TEST 10: Branch with large offset");
        $display("----------------------------------------");
        pc_prev = pc;
        jump = 0;
        branch = 1;
        branch_offset = 16'h0FFF;
        @(posedge clk);
        #1;
        expected_pc = pc_prev + 4 + (32'h00000FFF << 2);
        $display("  BranchOffset=0x%04h (+%d)", branch_offset, $signed(branch_offset));
        $display("  PC = 0x%08h (expected 0x%08h)", pc, expected_pc);
        if (pc === expected_pc)
            $display("PASSED\n");
        else
            $display("FAILED\n");
        
        #50;
        $finish;
    end

    initial begin
        $dumpfile("pc_calculator.vcd");
        $dumpvars(0, pc_calculator_tb);
    end

endmodule