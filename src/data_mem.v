`timescale 1ns/1ps
module data_mem(
    input clk, input re, input we, input [31:0] address,
    input [31:0] write_data, output reg [31:0] read_data
);
    reg [31:0] mem [0:255];
    integer i;
    initial begin
        for (i=0; i<256; i=i+1) mem[i]=32'b0;
    end
    always @(*) begin
        if (re && address < 256) read_data = mem[address[7:0]];
        else read_data = 32'b0;
    end
    always @(posedge clk) begin
        if (we && address < 256) mem[address[7:0]] <= write_data;
    end
endmodule
