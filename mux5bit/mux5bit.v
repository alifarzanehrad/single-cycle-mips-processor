`timescale 1ns/1ps
module mux5bit (
    input           sel,
    input      [4:0]in0,
    input      [4:0]in1,
    output     [4:0]out
);
    assign out = (sel == 1'b0)? in0 : in1;
endmodule
