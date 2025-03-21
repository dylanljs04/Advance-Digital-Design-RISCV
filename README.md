# Advanced Digital Design Risc-V

## Overview
This work involves designing, simulating, and testing a single-cycle-per-instruction RISC-V CPU using SystemVerilog, as well as developing and verifying RISC-V assembly programs. The key objectives achieved include:

- Implementing a RISC-V CPU using a hierarchical SystemVerilog description.
- Simulating the designed CPU modules using Icarus Verilog and GTKWave.
- Writing and testing RISC-V assembly programs through simulation.

![Block diagram of the designed RISC-V CPU](riscv-design.png)  
*Figure 1: Block diagram of the designed RISC-V CPU.*


## Project Structure

### SystemVerilog Modules:
- `program_counter.sv`: Manages program execution flow.
- `instruction_memory.sv`: Contains the machine code program.
- `control_unit.sv`: Decodes instructions and generates control signals.
- `reg_file.sv`: Provides register file functionality.
- `extend.sv`: Performs immediate value extension based on instruction type.
- `alu.sv`: Executes arithmetic and logic operations.
- `data_memory_and_io.sv`: Manages data memory operations and I/O interactions.
- `risc_v.sv`: Top-level module integrating all sub-blocks.

### Testbenches:
- Individual module testbenches:
  - `program_counter_tb.sv`
  - `control_unit_tb.sv`
  - `extend_tb.sv`
  - `alu_tb.sv`
- Top-level testbench:
  - `risc_v_tb.sv`

### Assembly Programs:
- **Counting Ones** (`count_ones.s`): Counts the number of '1's in the least significant byte of `CPUIn`.
- **Multiplication by Shift and Add** (`multiply_shift_add.s`): Multiplies two 8-bit values using the shift-and-add method.

## Simulation Tools
- **Icarus Verilog**: For compiling and simulating SystemVerilog modules.
- **GTKWave**: For visualizing waveforms and verifying correct functionality.
- **VS Code**: Editor for writing and managing code.

## Deliverables Included in the Submission
- Complete SystemVerilog code of CPU modules.
- Assembly code listings for implemented tasks.
- Simulation results (waveform images and text logs).
- Analysis and commentary verifying that modules and assembly programs behave as expected.

## Instructions to Run Simulations
- Ensure `program.txt` (machine code) and assembly `.s` files are correctly placed.
- Use Icarus Verilog to compile and simulate the provided testbenches.
- Open generated `.vcd` files using GTKWave to analyze waveforms.

## Author
- **Your Name:** Dylan Lim
- **Institution:** University College London (UCL)

