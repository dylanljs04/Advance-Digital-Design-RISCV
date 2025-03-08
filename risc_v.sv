`include "instruction_memory.sv"
`include "reg_file.sv"
`include "extend.sv"
`include "alu.sv"
`include "data_memory_and_io.sv"
`include "program_counter.sv"
`include "control_unit.sv"

module risc_v(output logic [31:0] CPUOut,
                input logic [31:0] CPUIn,
                input logic Reset, CLK);

logic [31:0] Instr, WD3, RD1, RD2, SrcA, SrcB, ALUResult, WD, RD, Result, ImmExt, PCTarget, PCNext, PC, PCPlus4;
logic [4:0]  A1, A2, A3;
logic        MemWrite, ALUSrc, RegWrite;
logic        Zero, Negative;
logic [4:0]  ALUControl;
logic [2:0]  ImmSrc;
logic [1:0]  ResultSrc;
logic [1:0]  PCSrc;

// Enter your code here

endmodule

