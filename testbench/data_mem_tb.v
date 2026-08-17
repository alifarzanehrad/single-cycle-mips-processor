`timescale 1ns/1ps
module data_mem_tb;
    reg clk=0,re=0,we=0; reg [31:0] address,write_data; wire [31:0] read_data;
    integer errors=0; always #5 clk=~clk;
    data_mem dut(.clk(clk),.re(re),.we(we),.address(address),.write_data(write_data),.read_data(read_data));
    initial begin
      address=7; write_data=32'h12345678; we=1; @(posedge clk); #1; we=0; re=1; #1;
      if(read_data!==32'h12345678) errors=errors+1;
      re=0; #1; if(read_data!==0) errors=errors+1;
      $display("data_mem_tb errors: %0d",errors); $finish;
    end
endmodule
