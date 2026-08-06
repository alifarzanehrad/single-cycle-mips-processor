`timescale 1ns/1ps

module top (
    input              clk,
    input              reset,
    output     [31:0]  pc_out,
    output     [31:0]  instruction_out,
    output     [31:0]  alu_result_out,
    output     [31:0]  read_data_out
);

    wire [31:0] instruction;
    wire        reg_dst, alu_src, mem_to_reg, reg_write, mem_read, mem_write, branch, jump;
    wire [1:0]  alu_op;
    wire [2:0]  alu_func;
    wire [31:0] read_data1, read_data2;
    wire [4:0]  write_reg;
    wire [31:0] alu_input2, alu_result, write_data, read_data, pc;
    wire        zero, branch_taken;
    wire [25:0] jump_address;
    wire [15:0] branch_offset;
    wire [5:0]  opcode, funct;
    wire [4:0]  rs, rt, rd, shamt;
    wire [15:0] imm;

    assign opcode        = instruction[31:26];
    assign rs             = instruction[25:21];
    assign rt             = instruction[20:16];
    assign rd             = instruction[15:11];
    assign shamt          = instruction[10:6];
    assign funct           = instruction[5:0];
    assign imm             = instruction[15:0];
    assign jump_address    = instruction[25:0];
    assign branch_offset   = instruction[15:0];

    pc_calculator pc_inst (
        .clk(clk), .reset(reset), .jump(jump), .branch(branch_taken),
        .jump_address(jump_address), .branch_offset(branch_offset), .pc(pc)
    );

    instr_mem instmem_inst (
        .address(pc), .instruction(instruction)
    );

    control control_inst (
        .opcode(opcode), .reg_dst(reg_dst), .alu_src(alu_src),
        .mem_to_reg(mem_to_reg), .reg_write(reg_write), .mem_read(mem_read),
        .mem_write(mem_write), .branch(branch), .alu_op(alu_op), .jump(jump)
    );

    alu_control alu_control_inst (
        .alu_op(alu_op), .funct(funct), .alu_func(alu_func)
    );

    mux #(.width(5)) mux_reg_dst (
        .sel(reg_dst), .in0(rt), .in1(rd), .out(write_reg)
    );

    registers reg_inst (
        .clk(clk), .clr(~reset), .regWrite(reg_write),
        .readReg1(rs), .readReg2(rt), .writeReg(write_reg), .writeData(write_data),
        .readData1(read_data1), .readData2(read_data2)
    );

    mux mux_alu_src (
        .sel(alu_src), .in0(read_data2), .in1({{16{imm[15]}}, imm}), .out(alu_input2)
    );

    alu alu_inst (
        .in1(read_data1), .in2(alu_input2), .func(alu_func), .shamt(shamt),
        .out(alu_result), .sign(), .overflow(), .zero(zero)
    );

    data_mem data_mem_inst (
        .clk(clk), .we(mem_write), .address(alu_result),
        .write_data(read_data2), .read_data(read_data)
    );

    mux mux_mem_to_reg (
        .sel(mem_to_reg), .in0(alu_result), .in1(read_data), .out(write_data)
    );

    assign branch_taken = branch & zero;

    assign pc_out           = pc;
    assign instruction_out  = instruction;
    assign alu_result_out   = alu_result;
    assign read_data_out    = read_data;

endmodule