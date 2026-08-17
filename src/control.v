`timescale 1ns/1ps
module control (
    input [5:0] opcode,
    output reg reg_dst, alu_src, mem_to_reg, reg_write, mem_read, mem_write,
    output reg branch, output reg [1:0] alu_op, output reg jump,
    output reg branch_ne, imm_zero_extend, lui
);
    always @(*) begin
        reg_dst=0; alu_src=0; mem_to_reg=0; reg_write=0; mem_read=0;
        mem_write=0; branch=0; alu_op=2'b00; jump=0;
        branch_ne=0; imm_zero_extend=0; lui=0;
        case (opcode)
            6'h00: begin reg_dst=1; reg_write=1; alu_op=2'b10; end
            6'h23: begin alu_src=1; mem_to_reg=1; reg_write=1; mem_read=1; end
            6'h2B: begin alu_src=1; mem_write=1; end
            6'h04: begin branch=1; alu_op=2'b01; end
            6'h05: begin branch=1; branch_ne=1; alu_op=2'b01; end
            6'h02: jump=1;
            6'h08, 6'h09, 6'h0A: begin // addi, addiu, slti
                alu_src=1; reg_write=1; alu_op=2'b11;
            end
            6'h0C, 6'h0D, 6'h0E: begin // andi, ori, xori
                alu_src=1; reg_write=1; alu_op=2'b11; imm_zero_extend=1;
            end
            6'h0F: begin // lui
                alu_src=1; reg_write=1; lui=1; imm_zero_extend=1;
            end
            default: begin end
        endcase
    end
endmodule
