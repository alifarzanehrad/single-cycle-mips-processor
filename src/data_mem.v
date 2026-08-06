`timescale 1ns/1ps
// Data memory: combinational read, synchronous write, word-addressed.
module data_mem (
    input                 clk,
    input                 we,
    input         [31:0]  address,
    input         [31:0]  write_data,
    output     reg[31:0]  read_data
);
    reg [31:0] mem [0:255];
    integer i;

    initial begin
        for (i = 0; i < 256; i = i + 1)
  mem[0] = 32'd0;   // F0
        mem[1] = 32'd1;   // F1
        mem[2] = 32'd1;   // ONE (step)
        mem[3] = 32'd18;  // LIMIT: remaining terms to generate (20 total - 2 preloaded)
        mem[4] = 32'd10;  // base storage address (word index)
    end

    always @(*) begin
        if (address < 256)
            read_data = mem[address[9:0]];
        else
            read_data = 32'h00000000;
    end

    always @(posedge clk) begin
        if (we && (address < 256))
            mem[address[9:0]] <= write_data;
    end
endmodule