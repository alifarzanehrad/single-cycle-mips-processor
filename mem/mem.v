`timescale 1ns/1ps

module mem (
    input                 clk,
    input                 we,           // Write Enable: 1=write, 0=read
    input         [31:0]  address,     
    input         [31:0]  write_data,   
    output     reg[31:0]  read_data     
);

    reg [31:0] mem [0:255];
    integer i;
    
    initial begin
        for (i = 0; i < 256; i = i + 1) begin
            mem[i] = 32'h00000000;
        end
        
        mem[0] = 32'h12345678;
        mem[1] = 32'hAABBCCDD;
        mem[2] = 32'hDEADBEEF;
    end
    
    always @(*) begin
        if (address < 256)
            read_data = mem[address[9:0]];  
        else
            read_data = 32'h00000000;       // Invalid address
    end
    
    always @(posedge clk) begin
        if (we && (address < 256)) begin
            mem[address[9:0]] <= write_data;
        end
    end

endmodule