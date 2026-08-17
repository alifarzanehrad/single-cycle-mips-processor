`timescale 1ns/1ps
module control_tb;
    reg [5:0] opcode;
    wire reg_dst,alu_src,mem_to_reg,reg_write,mem_read,mem_write,branch,jump;
    wire branch_ne,imm_zero_extend,lui; wire [1:0] alu_op; integer errors=0;
    control dut(.opcode(opcode),.reg_dst(reg_dst),.alu_src(alu_src),
      .mem_to_reg(mem_to_reg),.reg_write(reg_write),.mem_read(mem_read),
      .mem_write(mem_write),.branch(branch),.alu_op(alu_op),.jump(jump),
      .branch_ne(branch_ne),.imm_zero_extend(imm_zero_extend),.lui(lui));
    task check_control; input rw,asrc,b,ne,zeroext,lui_exp; input [1:0] op; begin #1;
      if({reg_write,alu_src,branch,branch_ne,imm_zero_extend,lui,alu_op} !==
         {rw,asrc,b,ne,zeroext,lui_exp,op}) errors=errors+1;
    end endtask
    initial begin
      opcode=6'h08; check_control(1,1,0,0,0,0,2'b11);
      opcode=6'h0c; check_control(1,1,0,0,1,0,2'b11);
      opcode=6'h05; check_control(0,0,1,1,0,0,2'b01);
      opcode=6'h0f; check_control(1,1,0,0,1,1,2'b00);
      $display("control_tb errors: %0d",errors); $finish;
    end
endmodule
