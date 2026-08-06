`timescale 1ns/1ps
// Instruction memory: combinational (asynchronous) read, byte-addressed.
module instr_mem (
    input      [31:0]  address,
    output     [31:0]  instruction
);
    reg [7:0] mem [0:1023];
    integer i;

    initial begin
        for (i = 0; i < 1024; i = i + 1)
            mem[i] = 8'h00;

        {mem[0],mem[1],mem[2],mem[3]}     = 32'h8C010000; // lw   $1, 0($0)
        {mem[4],mem[5],mem[6],mem[7]}     = 32'h8C020001; // lw   $2, 1($0)
        {mem[8],mem[9],mem[10],mem[11]}   = 32'h00221820; // add  $3, $1, $2
        {mem[12],mem[13],mem[14],mem[15]} = 32'hAC030003; // sw   $3, 3($0)
        {mem[16],mem[17],mem[18],mem[19]} = 32'h8C040003; // lw   $4, 3($0)
        {mem[20],mem[21],mem[22],mem[23]} = 32'h10000001; // beq  $0, $0, 1
        {mem[24],mem[25],mem[26],mem[27]} = 32'hFFFFFFFF; // 0x18: must be skipped
        {mem[28],mem[29],mem[30],mem[31]} = 32'h00812820; // 0x1C: add $5, $4, $1
    end

    assign instruction = {mem[address[9:0]], mem[address[9:0]+1],
                           mem[address[9:0]+2], mem[address[9:0]+3]};
endmodule