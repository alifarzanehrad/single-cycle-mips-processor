`timescale 1ns/1ps

module pc_calculator (
    input              clk,
    input              reset,          // Active Low
    input              jump,
    input              branch,
    input      [25:0]  jump_address,
    input      [15:0]  branch_offset,
    output     [31:0]  pc
);

    reg  [31:0] pc_reg;
    wire [31:0] pc_plus_4;
    wire [31:0] branch_target;
    wire [31:0] jump_target;
    wire [31:0] pc_next;
    
    // PC + 4
    assign pc_plus_4 = pc_reg + 4;
    
    // Branch Target: PC + 4 + (SignExtend(BranchOffset) << 2)
    wire [31:0] offset_extended;
    assign offset_extended = {{16{branch_offset[15]}}, branch_offset};
    assign branch_target = pc_plus_4 + (offset_extended << 2);
    
    // Jump Target: {PC[31:28], JumpAddress, 2'b00}
    assign jump_target = {pc_reg[31:28], jump_address, 2'b00};
    
    always @(*) begin
        if (reset == 1'b0) begin
            pc_next = 32'h00000000;  // Reset
        end else if (jump == 1'b1 && branch == 1'b0) begin
            pc_next = jump_target;   // Jump
        end else if (jump == 1'b0 && branch == 1'b1) begin
            pc_next = branch_target; // Branch
        end else if (jump == 1'b0 && branch == 1'b0) begin
            pc_next = pc_plus_4;     // Normal
        end else begin
            pc_next = 32'hxxxxxxxx;  //(Jump=1, Branch=1)
        end
    end
    
    always @(posedge clk) begin
        pc_reg <= pc_next;
    end
    
    assign pc = pc_reg;

endmodule