# Single-Cycle MIPS Processor

[![Verify RTL](https://github.com/alifarzanehrad/single-cycle-mips-processor/actions/workflows/verify.yml/badge.svg)](https://github.com/alifarzanehrad/single-cycle-mips-processor/actions/workflows/verify.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

A modular single-cycle MIPS-like processor written in Verilog and verified with
Icarus Verilog. The repository contains the datapath, control logic, reusable
program images, module-level tests, and end-to-end processor tests.

![Datapath Diagram](docs/datapath_diagram.png)

## Architecture

The core follows the classic single-cycle organization: instruction fetch,
decode and control, two-read/one-write register file, ALU, data memory, and
next-PC logic. Every instruction completes in one clock cycle. Branch targets
are calculated relative to `PC+4`, and jump targets use the upper bits of
`PC+4`.

The design is divided into small synthesizable modules so that the ALU, decoder,
memories, register file, and PC logic can be tested independently before the
complete processor is exercised.

## Supported instructions

| Class | Instructions |
|---|---|
| Arithmetic | `add`, `addu`, `sub`, `subu`, `addi`, `addiu` |
| Logical | `and`, `or`, `xor`, `nor`, `andi`, `ori`, `xori` |
| Shift | `sll`, `srl`, `sra` |
| Compare | `slt`, `sltu`, `slti` |
| Memory | `lw`, `sw` |
| Control flow | `beq`, `bne`, `j` |
| Immediate construction | `lui` |

Signed and unsigned comparisons are implemented separately. Logical immediate
instructions use zero extension; arithmetic and branch immediates use sign
extension.

## Project structure

- `src/` — synthesizable processor RTL
- `testbench/` — module and integration testbenches
- `programs/` — machine-code programs loaded with `$readmemh`
- `docs/` — datapath diagram and project notes

The included Fibonacci program uses `addi` for constants, counters, and pointer
updates, and stores the first 20 terms at data-memory word addresses 10 through
29.

## Run tests

### Requirements

- GNU Make
- Icarus Verilog with SystemVerilog 2012 support

On macOS:

```bash
brew install icarus-verilog
```

Run the complete verification suite:

```bash
make test
```

The test suite covers ALU operations (including signed shifts and comparisons),
instruction decoding, memories, register file, PC behavior, immediate
extension, branches, and an end-to-end instruction program. `fib_tb` verifies
the first 20 Fibonacci values.

The same command runs automatically in GitHub Actions on every push and pull
request. A successful run requires every testbench to finish with zero errors.

## Running a program

Programs are stored as one 32-bit hexadecimal instruction per line under
`programs/`. Select a program when instantiating the processor:

```verilog
top #(.PROGRAM_FILE("programs/fibonacci.hex")) dut (...);
```

`programs/instruction_test.hex` exercises arithmetic, logical immediate,
comparison, shift, memory, and branch instructions. `programs/fibonacci.hex`
generates and stores the first 20 Fibonacci numbers.

## Memory model

Instruction memory is byte-addressed through the PC and stores 32-bit words.
Data memory is intentionally **word-addressed** in this educational core, so
`lw $t0, 1($zero)` selects data-memory word 1 rather than byte address 1. This is
the main deliberate difference from standard MIPS memory addressing.

## Current scope

- One instruction completes per clock cycle.
- No pipeline, forwarding, stalls, exceptions, interrupts, or HI/LO unit.
- Arithmetic overflow is exposed by the ALU but does not raise an exception.
- Sub-word loads and stores and function-call instructions (`jal`/`jr`) are not
  implemented yet.

## Roadmap

- Make data memory byte-addressed and add `lb`, `lbu`, `lh`, `lhu`, `sb`, and
  `sh`.
- Add `jal`, `jr`, and a program containing reusable subroutines.
- Add linting and functional coverage alongside the directed testbenches.
- Synthesize the core for an FPGA and publish resource utilization, maximum
  clock frequency, and on-board results.
- Build a separate five-stage pipelined RISC-V core with forwarding, stalls,
  and hazard detection.

## License

MIT
