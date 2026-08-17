`timescale 1ns/1ps
module alu (
    input [31:0] in1, input [31:0] in2, input [3:0] func,
    input [4:0] shamt,
    output reg [31:0] out, output reg sign, output reg overflow, output reg zero
);
    localparam ADD=4'h0, SUB=4'h1, AND_OP=4'h2, OR_OP=4'h3,
               XOR_OP=4'h4, SLL=4'h5, SRL=4'h6, SLT=4'h7,
               NOR_OP=4'h8, SRA=4'h9, SLTU=4'hA;
    always @(*) begin
        out = 32'b0;
        overflow = 1'b0;
        case (func)
            ADD: begin
                out = in1 + in2;
                overflow = (~(in1[31] ^ in2[31])) & (out[31] ^ in1[31]);
            end
            SUB: begin
                out = in1 - in2;
                overflow = (in1[31] ^ in2[31]) & (out[31] ^ in1[31]);
            end
            AND_OP: out = in1 & in2;
            OR_OP:  out = in1 | in2;
            XOR_OP: out = in1 ^ in2;
            SLL:    out = in2 << shamt;
            SRL:    out = in2 >> shamt;
            SLT:    out = ($signed(in1) < $signed(in2)) ? 32'd1 : 32'd0;
            NOR_OP: out = ~(in1 | in2);
            SRA:    out = $signed(in2) >>> shamt;
            SLTU:   out = (in1 < in2) ? 32'd1 : 32'd0;
            default: out = 32'b0;
        endcase
        zero = (out == 32'b0);
        sign = out[31];
    end
endmodule
