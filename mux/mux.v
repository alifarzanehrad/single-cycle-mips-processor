`timescale 1ns/1ps
module mux #(
    parameter width = 32
)(
    input                   sel,
    input      [width - 1:0]in0,
    input      [width - 1:0]in1,
    output     [width - 1:0]out
);
    assign out = (sel == 1'b0)? in0 : in1;
endmodule
