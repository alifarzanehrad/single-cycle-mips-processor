`timescale 1ns/1ps

module control (
    input      [5:0]  opcode,
    output reg        reg_dst,
    output reg        alu_src,
    output reg        mem_to_reg,
    output reg        reg_write,
    output reg        mem_read,
    output reg        mem_write,
    output reg        branch,
    output reg [1:0]  alu_op,
    output reg        jump
);

    always @(*) begin
        // Default values (prevent latches)
        reg_dst    = 1'b0;
        alu_src    = 1'b0;
        mem_to_reg = 1'b0;
        reg_write  = 1'b0;
        mem_read   = 1'b0;
        mem_write  = 1'b0;
        branch     = 1'b0;
        alu_op     = 2'b00;
        jump       = 1'b0;
        
        case (opcode)
            6'b000000: begin  // R-type
                reg_dst    = 1'b1;
                alu_src    = 1'b0;
                mem_to_reg = 1'b0;
                reg_write  = 1'b1;
                mem_read   = 1'b0;
                mem_write  = 1'b0;
                branch     = 1'b0;
                alu_op     = 2'b10;
                jump       = 1'b0;
            end
            
            6'b100011: begin  // lw
                reg_dst    = 1'b0;
                alu_src    = 1'b1;
                mem_to_reg = 1'b1;
                reg_write  = 1'b1;
                mem_read   = 1'b1;
                mem_write  = 1'b0;
                branch     = 1'b0;
                alu_op     = 2'b00;
                jump       = 1'b0;
            end
            
            6'b101011: begin  // sw
                reg_dst    = 1'b0;
                alu_src    = 1'b1;
                mem_to_reg = 1'b0;
                reg_write  = 1'b0;
                mem_read   = 1'b0;
                mem_write  = 1'b1;
                branch     = 1'b0;
                alu_op     = 2'b00;
                jump       = 1'b0;
            end
            
            6'b000100: begin  // beq
                reg_dst    = 1'b0;
                alu_src    = 1'b0;
                mem_to_reg = 1'b0;
                reg_write  = 1'b0;
                mem_read   = 1'b0;
                mem_write  = 1'b0;
                branch     = 1'b1;
                alu_op     = 2'b01;
                jump       = 1'b0;
            end
            
            6'b000010: begin  // j
                reg_dst    = 1'b0;
                alu_src    = 1'b0;
                mem_to_reg = 1'b0;
                reg_write  = 1'b0;
                mem_read   = 1'b0;
                mem_write  = 1'b0;
                branch     = 1'b0;
                alu_op     = 2'b00;
                jump       = 1'b1;
            end
            
            default: begin
                // All outputs already have default values
            end
        endcase
    end

endmodule