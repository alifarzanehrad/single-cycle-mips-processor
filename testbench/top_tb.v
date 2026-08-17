`timescale 1ns/1ps
module top_tb;
    reg clk,reset; wire [31:0] pc,instruction,alu_result,read_data;
    integer errors=0; always #5 clk=~clk;
    top #(.PROGRAM_FILE("programs/instruction_test.hex")) dut(
      .clk(clk),.reset(reset),.pc_out(pc),.instruction_out(instruction),
      .alu_result_out(alu_result),.read_data_out(read_data));
    task reg_check; input [4:0] index; input [31:0] expected; begin
      if(dut.reg_inst.regs[index]!==expected) begin
        $display("FAIL r%0d got=%h expected=%h",index,dut.reg_inst.regs[index],expected); errors=errors+1;
      end
    end endtask
    initial begin
      clk=0; reset=0;
      #3 reset=1;
      repeat(18) @(posedge clk); #1;
      reg_check(1,5); reg_check(2,32'hfffffffe); reg_check(3,3); reg_check(4,3);
      reg_check(5,32'h1234); reg_check(6,32'habcd0000); reg_check(7,32'h34);
      reg_check(8,32'hcb); reg_check(9,1); reg_check(10,20);
      reg_check(11,32'hffffffff); reg_check(12,~(32'd5|32'hfffffffe)); reg_check(13,1);
      if(dut.data_mem_inst.mem[3]!==3) errors=errors+1;
      $display("top_tb errors: %0d",errors); $finish;
    end
endmodule
