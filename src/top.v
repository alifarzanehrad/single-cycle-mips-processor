`timescale 1ns/1ps
module top #(
    parameter PROGRAM_FILE = "programs/fibonacci.hex"
) (
    input clk, input reset,
    output [31:0] pc_out, instruction_out, alu_result_out, read_data_out
);
    wire [31:0] instruction, pc, read_data1, read_data2, immediate;
    wire [31:0] alu_input2, alu_result, memory_data, normal_write_data, write_data;
    wire reg_dst, alu_src, mem_to_reg, reg_write, mem_read, mem_write;
    wire branch, branch_ne, jump, imm_zero_extend, lui, zero, branch_taken;
    wire [1:0] alu_op;
    wire [3:0] alu_func;
    wire [4:0] write_reg;

    wire [5:0] opcode = instruction[31:26];
    wire [4:0] rs = instruction[25:21];
    wire [4:0] rt = instruction[20:16];
    wire [4:0] rd = instruction[15:11];
    wire [4:0] shamt = instruction[10:6];
    wire [5:0] funct = instruction[5:0];
    wire [15:0] imm = instruction[15:0];

    assign immediate = imm_zero_extend ? {16'b0, imm} : {{16{imm[15]}}, imm};

    pc_calculator pc_inst(
        .clk(clk), .reset(reset), .jump(jump), .branch(branch_taken),
        .jump_address(instruction[25:0]), .branch_offset(imm), .pc(pc));
    instr_mem #(.INIT_FILE(PROGRAM_FILE)) instmem_inst(.address(pc), .instruction(instruction));
    control control_inst(
        .opcode(opcode), .reg_dst(reg_dst), .alu_src(alu_src),
        .mem_to_reg(mem_to_reg), .reg_write(reg_write), .mem_read(mem_read),
        .mem_write(mem_write), .branch(branch), .alu_op(alu_op), .jump(jump),
        .branch_ne(branch_ne), .imm_zero_extend(imm_zero_extend), .lui(lui));
    alu_control alu_control_inst(.alu_op(alu_op), .opcode(opcode),
        .funct(funct), .alu_func(alu_func));
    mux #(.width(5)) mux_reg_dst(.sel(reg_dst), .in0(rt), .in1(rd), .out(write_reg));
    registers reg_inst(
        .clk(clk), .clr(~reset), .regWrite(reg_write), .readReg1(rs),
        .readReg2(rt), .writeReg(write_reg), .writeData(write_data),
        .readData1(read_data1), .readData2(read_data2));
    mux mux_alu_src(.sel(alu_src), .in0(read_data2), .in1(immediate), .out(alu_input2));
    alu alu_inst(.in1(read_data1), .in2(alu_input2), .func(alu_func),
        .shamt(shamt), .out(alu_result), .sign(), .overflow(), .zero(zero));
    data_mem data_mem_inst(.clk(clk), .re(mem_read), .we(mem_write),
        .address(alu_result), .write_data(read_data2), .read_data(memory_data));
    mux mux_mem_to_reg(.sel(mem_to_reg), .in0(alu_result),
        .in1(memory_data), .out(normal_write_data));
    assign write_data = lui ? {imm, 16'b0} : normal_write_data;
    assign branch_taken = branch & (branch_ne ? ~zero : zero);
    assign pc_out=pc; assign instruction_out=instruction;
    assign alu_result_out=alu_result; assign read_data_out=memory_data;
endmodule
