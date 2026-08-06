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

        {mem[0],mem[1],mem[2],mem[3]}     = 32'h8C010000; // 0x00 lw   $1, 0($0)   F0
        {mem[4],mem[5],mem[6],mem[7]}     = 32'h8C020001; // 0x04 lw   $2, 1($0)   F1
        {mem[8],mem[9],mem[10],mem[11]}   = 32'h8C030002; // 0x08 lw   $3, 2($0)   ONE
        {mem[12],mem[13],mem[14],mem[15]} = 32'h8C040003; // 0x0C lw   $4, 3($0)   LIMIT
        {mem[16],mem[17],mem[18],mem[19]} = 32'h8C060004; // 0x10 lw   $6, 4($0)   base addr
        {mem[20],mem[21],mem[22],mem[23]} = 32'hACC10000; // 0x14 sw   $1, 0($6)   store F0
        {mem[24],mem[25],mem[26],mem[27]} = 32'hACC20001; // 0x18 sw   $2, 1($6)   store F1
        {mem[28],mem[29],mem[30],mem[31]} = 32'h00002820; // 0x1C add  $5, $0, $0  counter=0
        {mem[32],mem[33],mem[34],mem[35]} = 32'h00C33020; // 0x20 add  $6, $6, $3  ptr = base+1
        {mem[36],mem[37],mem[38],mem[39]} = 32'h00C33020; // 0x24 add  $6, $6, $3  ptr = base+2

        // loop (0x28)
        {mem[40],mem[41],mem[42],mem[43]} = 32'h10A40007; // 0x28 beq  $5, $4, exit
        {mem[44],mem[45],mem[46],mem[47]} = 32'h00223820; // 0x2C add  $7, $1, $2  new = F(n-2)+F(n-1)
        {mem[48],mem[49],mem[50],mem[51]} = 32'hACC70000; // 0x30 sw   $7, 0($6)
        {mem[52],mem[53],mem[54],mem[55]} = 32'h00400820; // 0x34 add  $1, $2, $0
        {mem[56],mem[57],mem[58],mem[59]} = 32'h00E01020; // 0x38 add  $2, $7, $0
        {mem[60],mem[61],mem[62],mem[63]} = 32'h00C33020; // 0x3C add  $6, $6, $3  ptr++
        {mem[64],mem[65],mem[66],mem[67]} = 32'h00A32820; // 0x40 add  $5, $5, $3  counter++
        {mem[68],mem[69],mem[70],mem[71]} = 32'h1000FFF8; // 0x44 beq  $0, $0, loop

        // exit (0x48)
        {mem[72],mem[73],mem[74],mem[75]} = 32'h00000020; // add $0,$0,$0 (halt)
    end

    assign instruction = {mem[address[9:0]], mem[address[9:0]+1],
                           mem[address[9:0]+2], mem[address[9:0]+3]};
endmodule