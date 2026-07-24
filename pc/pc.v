`timescale 1ns/1ps

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
    wire [31:0] pc_plus_4;
    wire [31:0] branch_target;
    wire [31:0] jump_target;
    reg  [31:0] pc_next;
    
    assign pc_plus_4 = pc_reg + 4;
    
    wire [31:0] offset_extended;
    assign offset_extended = {{16{branch_offset[15]}}, branch_offset};
    assign branch_target = pc_plus_4 + (offset_extended << 2);
    
    assign jump_target = {pc_reg[31:28], jump_address, 2'b00};
    
    always @(*) begin
        if (reset == 1'b0) begin
            pc_next = 32'h00000000;
        end else if (jump == 1'b1 && branch == 1'b0) begin
            pc_next = jump_target;
        end else if (jump == 1'b0 && branch == 1'b1) begin
            pc_next = branch_target;
        end else if (jump == 1'b0 && branch == 1'b0) begin
            pc_next = pc_plus_4;
        end else begin
            pc_next = 32'hxxxxxxxx;
        end
    end
    
    always @(posedge clk) begin
        pc_reg <= pc_next;
    end
    
    assign pc = pc_reg;

endmodule