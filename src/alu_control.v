`timescale 1ns/1ps
module alu_control (
    input [1:0] alu_op, input [5:0] opcode, input [5:0] funct,
    output reg [3:0] alu_func
);
    always @(*) begin
        alu_func = 4'h0;
        case (alu_op)
            2'b01: alu_func = 4'h1; // beq/bne
            2'b10: begin
                case (funct)
                    6'h20, 6'h21: alu_func = 4'h0; // add/addu
                    6'h22, 6'h23: alu_func = 4'h1; // sub/subu
                    6'h24: alu_func = 4'h2;
                    6'h25: alu_func = 4'h3;
                    6'h26: alu_func = 4'h4;
                    6'h00: alu_func = 4'h5;
                    6'h02: alu_func = 4'h6;
                    6'h2A: alu_func = 4'h7;
                    6'h27: alu_func = 4'h8;
                    6'h03: alu_func = 4'h9;
                    6'h2B: alu_func = 4'hA;
                    default: alu_func = 4'h0;
                endcase
            end
            2'b11: begin
                case (opcode)
                    6'h0C: alu_func = 4'h2; // andi
                    6'h0D: alu_func = 4'h3; // ori
                    6'h0E: alu_func = 4'h4; // xori
                    6'h0A: alu_func = 4'h7; // slti
                    default: alu_func = 4'h0; // addi/addiu
                endcase
            end
            default: alu_func = 4'h0; // address calculation
        endcase
    end
endmodule
