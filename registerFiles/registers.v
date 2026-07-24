`timescale 1ns/1ps
module registers (
    input           clk,
    input           clr,
    input           regWrite,
    input    [4:0]  readReg1,
    input    [4:0]  readReg2,
    input    [4:0]  writeReg,
    input    [31:0] writeData,
    output   [31:0] readData1,
    output   [31:0] readData2
);
    reg [31:0] regs [31:0];
    integer i;
    always @(posedge clk or posedge clr) begin
        if (clr) begin
            for (i = 0; i < 32; i = i + 1) begin
                regs[i] <= 32'b0;
            end
        end else if (regWrite) begin
            regs[writeReg] <= writeData;
        end
    end
    assign readData1 = regs[readReg1];
    assign readData2 = regs[readReg2];
endmodule