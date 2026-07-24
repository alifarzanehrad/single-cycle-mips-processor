`timescale 1ns/1ps

module instrmem (
    input              clk,
    input      [9:0]   address,      
    output     [31:0]  instruction
);

    reg [7:0] mem [0:1023];          
    reg [31:0] data_reg;
    integer i;  
    
    initial begin
        for (i = 0; i < 1024; i = i + 1) begin
            mem[i] = 8'h00;
        end
        
        mem[0]  = 8'h34;
        mem[1]  = 8'h12;
        mem[2]  = 8'h01;
        mem[3]  = 8'h3C;

        mem[4]  = 8'h78;
        mem[5]  = 8'h56;
        mem[6]  = 8'h22;
        mem[7]  = 8'h34;
        
        mem[8]  = 8'h00;
        mem[9]  = 8'h00;
        mem[10] = 8'h02;
        mem[11] = 8'hAC;
        
        mem[12] = 8'h00;
        mem[13] = 8'h00;
        mem[14] = 8'h03;
        mem[15] = 8'h8C;
        
        mem[16] = 8'h20;
        mem[17] = 8'h18;
        mem[18] = 8'h44;
        mem[19] = 8'h00;
        
        mem[20] = 8'h22;
        mem[21] = 8'h20;
        mem[22] = 8'h85;
        mem[23] = 8'h00;
        
        mem[24] = 8'h28;
        mem[25] = 8'h25;
        mem[26] = 8'h86;
        mem[27] = 8'h00;
        
        mem[28] = 8'h2A;
        mem[29] = 8'h25;
        mem[30] = 8'h87;
        mem[31] = 8'h00;
    end
    
    always @(posedge clk) begin
        data_reg <= {mem[address], mem[address+1], mem[address+2], mem[address+3]};
    end
    
    assign instruction = data_reg;

endmodule