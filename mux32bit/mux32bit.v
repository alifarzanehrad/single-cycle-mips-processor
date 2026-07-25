`timescale 1ns/1ps
module mux32bit (
    input            sel,
    input      [31:0]in0,
    input      [31:0]in1,
    output     [31:0]out
);
    assign out = (sel == 1'b0)? in0 : in1;
endmodule