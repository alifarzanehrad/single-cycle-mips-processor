`timescale 1ns/1ps
module instr_mem #(
    parameter INIT_FILE = "programs/fibonacci.hex",
    parameter WORD_COUNT = 17
) (input [31:0] address, output [31:0] instruction);
    reg [31:0] mem [0:255];
    integer i;
    initial begin
        for (i=0; i<256; i=i+1) mem[i]=32'b0;
        $readmemh(INIT_FILE, mem, 0, WORD_COUNT-1);
    end
    assign instruction = (address[31:10] == 0) ? mem[address[9:2]] : 32'b0;
endmodule
