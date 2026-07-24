`timescale 1ns/1ps

module instrmem (
    input              clk,
    input      [31:0]  address,      // 32-bit address input
    output     [31:0]  instruction   // 32-bit instruction output
);

    // Memory array: 1024 bytes (256 instructions of 32 bits each)
    reg [7:0] mem [0:1023];
    reg [31:0] data_reg;
    integer i;
    
    // Initialize memory with test instructions
    initial begin
        // Clear all memory locations
        for (i = 0; i < 1024; i = i + 1) begin
            mem[i] = 8'h00;
        end
        
        // Instruction 1: 0x3412013C (lui $2, 0x013C)
        mem[0]  = 8'h34;  
        mem[1]  = 8'h12;
        mem[2]  = 8'h01;
        mem[3]  = 8'h3C;  
        
        // Instruction 2: 0x56782234
        mem[4]  = 8'h56;
        mem[5]  = 8'h78;
        mem[6]  = 8'h22;
        mem[7]  = 8'h34;
        
        // Instruction 3: 0x000002AC
        mem[8]  = 8'h00;
        mem[9]  = 8'h00;
        mem[10] = 8'h02;
        mem[11] = 8'hAC;
        
        // Instruction 4: 0x0000038C
        mem[12] = 8'h00;
        mem[13] = 8'h00;
        mem[14] = 8'h03;
        mem[15] = 8'h8C;
    end
    
    // Read instruction from memory on rising edge of clock
    // address[11:2] is used for word-aligned addressing (divide by 4)
    always @(posedge clk) begin
        data_reg <= {mem[address[9:0] + 0],   // MSB
                     mem[address[9:0] + 1], 
                     mem[address[9:0] + 2], 
                     mem[address[9:0] + 3]};  // LSB
    end
    
    // Continuous assignment for instruction output
    assign instruction = data_reg;

endmodule