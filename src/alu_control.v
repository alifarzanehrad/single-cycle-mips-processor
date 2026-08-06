`timescale 1ns/1ps
// Maps opcode-derived alu_op and R-type funct to the ALU's func select.
module alu_control (
    input      [1:0]  alu_op,
    input      [5:0]  funct,
    output reg [2:0]  alu_func
);
    always @(*) begin
        case (alu_op)
            2'b00: alu_func = 3'b000;  // lw/sw -> ADD
            2'b01: alu_func = 3'b001;  // beq   -> SUB
            2'b10: begin
                case (funct)
                    6'b100000: alu_func = 3'b000;  // add
                    6'b100010: alu_func = 3'b001;  // sub
                    6'b100100: alu_func = 3'b010;  // and
                    6'b100101: alu_func = 3'b011;  // or
                    6'b100110: alu_func = 3'b100;  // xor
                    6'b000000: alu_func = 3'b101;  // sll
                    6'b000010: alu_func = 3'b110;  // srl
                    6'b101010: alu_func = 3'b111;  // slt
                    default:   alu_func = 3'b000;
                endcase
            end
            default: alu_func = 3'b000;
        endcase
    end
endmodule