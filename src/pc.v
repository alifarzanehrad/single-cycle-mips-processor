`timescale 1ns/1ps
module pc_calculator(
    input clk, input reset, input jump, input branch,
    input [25:0] jump_address, input [15:0] branch_offset,
    output [31:0] pc
);
    reg [31:0] pc_reg, pc_next;
    wire [31:0] pc_plus_4 = pc_reg + 32'd4;
    wire [31:0] offset_extended = {{16{branch_offset[15]}},branch_offset};
    wire [31:0] branch_target = pc_plus_4 + (offset_extended << 2);
    wire [31:0] jump_target = {pc_plus_4[31:28],jump_address,2'b00};
    always @(*) begin
      if(jump) pc_next=jump_target;
      else if(branch) pc_next=branch_target;
      else pc_next=pc_plus_4;
    end
    always @(posedge clk or negedge reset) begin
      if(!reset) pc_reg<=0; else pc_reg<=pc_next;
    end
    assign pc=pc_reg;
endmodule
