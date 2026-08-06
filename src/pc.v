`timescale 1ns/1ps
// Program counter: async active-low reset, computes next PC each cycle.
module pc_calculator (
    input              clk,
    input              reset,
    input              jump,
    input              branch,
    input      [25:0]  jump_address,
    input      [15:0]  branch_offset,
    output     [31:0]  pc
);
    reg  [31:0] pc_reg;
    wire [31:0] pc_plus_4 = pc_reg + 4;
    wire [31:0] offset_extended = {{16{branch_offset[15]}}, branch_offset};
    wire [31:0] branch_target = pc_plus_4 + (offset_extended << 2);
    wire [31:0] jump_target = {pc_reg[31:28], jump_address, 2'b00};
    reg  [31:0] pc_next;

    always @(*) begin
        if (jump && !branch)
            pc_next = jump_target;
        else if (!jump && branch)
            pc_next = branch_target;
        else
            pc_next = pc_plus_4;
    end

    always @(posedge clk or negedge reset) begin
        if (!reset)
            pc_reg <= 32'h00000000;
        else
            pc_reg <= pc_next;
    end

    assign pc = pc_reg;
endmodule