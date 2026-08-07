# Single-Cycle MIPS Processor

A single-cycle implementation of a MIPS-like processor, written in Verilog
and verified with Icarus Verilog (iverilog).

## Overview

This project implements the classic single-cycle MIPS datapath: instruction
fetch, register file, ALU, data memory, and control logic, all completing
in one clock cycle per instruction.

![Datapath Diagram](docs/datapath_diagram.png)

## Supported Instructions

| Instruction | Opcode   | Type | Description        |
|-------------|----------|------|---------------------|
| add, sub    | 000000   | R    | Arithmetic          |
| and, or, xor| 000000   | R    | Logical             |
| sll, srl    | 000000   | R    | Shift               |
| slt         | 000000   | R    | Set less than       |
| lw          | 100011   | I    | Load word           |
| sw          | 101011   | I    | Store word          |
| beq         | 000100   | I    | Branch if equal     |
| j           | 000010   | J    | Jump                |

## Project Structure

- `src/` — RTL source files
- `testbench/` — per-module and top-level testbenches
- `programs/` — example programs written directly as machine code in the
  instruction memory (e.g. a Fibonacci sequence generator)
- `docs/` — diagrams and notes

## How to Run

Requires [Icarus Verilog](http://iverilog.icarus.com/).

```bash
iverilog -o top_tb.vvp testbench/top_tb.v src/top.v src/alu.v \
  src/alu_control.v src/control.v src/instr_mem.v src/data_mem.v \
  src/mux.v src/pc.v src/registers.v
vvp top_tb.vvp
```

Each module also has its own standalone testbench under `testbench/`,
runnable the same way with just that module's source file.

## Testing

Every module is verified independently before integration:

- ALU: arithmetic, logic, shift, overflow, zero flag
- ALU control: opcode/funct to ALU operation mapping
- Control unit: control signal generation for every supported opcode
- Register file: read/write, clear, simultaneous dual-port read
- Data memory / instruction memory: read/write, out-of-range handling
- PC: reset, sequential increment, branch target, jump target

The top-level testbench runs a small program (load, add, store, load-back,
branch) and checks ALU results and memory reads against expected values
at each cycle.

## Known Limitations

- Single-cycle only — no pipelining, no hazard forwarding
- No immediate-arithmetic instructions (addi, andi, etc.)
- Instruction and data memories are small, fixed-size arrays sized for
  test programs, not a full address space

## Roadmap

A pipelined version of this processor (with hazard detection and
forwarding) is in progress as a separate project: [link when ready]

## License

MIT
