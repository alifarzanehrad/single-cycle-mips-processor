`timescale 1ns/1ps
module instr_mem_tb;
    reg [31:0] address; wire [31:0] instruction; integer errors=0;
    instr_mem #(.INIT_FILE("programs/instruction_test.hex")) dut(.address(address),.instruction(instruction));
    initial begin
      address=0; #1; if(instruction!==32'h20010005) errors=errors+1;
      address=4; #1; if(instruction!==32'h2002fffe) errors=errors+1;
      $display("instr_mem_tb errors: %0d",errors); $finish;
    end
endmodule
