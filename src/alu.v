`timescale 1ns/1ps
// ALU: performs arithmetic and logic operations selected by func.
module alu (
    input   [31:0]in1,
    input   [31:0]in2,
    input   [2:0]func,
    input   [4:0]shamt,
    output  reg[31:0]out,
    output  reg sign,
    output  reg overflow,
    output  reg zero
);
    always @(*) begin
        overflow = 1'b0;
        case (func)
            3'b000: begin
                out = in1 + in2; // ADD
                overflow = (in1[31] && in2[31] && !out[31]) || (!in1[31] && !in2[31] && out[31]);
            end
            3'b001: begin
                out = in1 - in2; // SUB
                overflow = (in1[31] && !in2[31] && !out[31]) || (!in1[31] && in2[31] && out[31]);
            end
            3'b010: out = in1 & in2;                     // AND
            3'b011: out = in1 | in2;                     // OR
            3'b100: out = in1 ^ in2;                     // XOR
            3'b101: out = in1 << shamt;                  // SLL
            3'b110: out = in1 >> shamt;                  // SRL
            3'b111: out = (in1 < in2) ? 32'd1 : 32'd0;   // SLT
            default: out = 32'd0;
        endcase
        zero = (out == 32'd0);
        sign = out[31];
    end
endmodule