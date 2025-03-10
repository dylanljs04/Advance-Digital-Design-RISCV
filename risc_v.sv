`include "instruction_memory.sv"
`include "reg_file.sv"
`include "extend/extend.sv"
`include "alu/alu.sv"
`include "data_memory_and_io.sv"
`include "program_counter/program_counter.sv"
`include "control_unit/control_unit.sv"

module risc_v(
    output logic [31:0] CPUOut,    // Data written out (if address == 0x7FFFFFFC)
    input  logic [31:0] CPUIn,     // Data read in  (if address == 0x7FFFFFFC)
    input  logic Reset, CLK
    );

    logic [31:0] Instr, WD3, RD1, RD2, SrcA, SrcB, ALUResult, RD, Result, ImmExt, PCTarget, PC, PCPlus4;
    logic [4:0]  A1, A2, A3;
    logic        MemWrite, ALUSrc, RegWrite;
    logic        Zero, Negative;
    logic [4:0]  ALUControl;
    logic [2:0]  ImmSrc;
    logic [1:0]  ResultSrc;
    logic [1:0]  PCSrc;

    // logic [31:0] WD, PCNext,     // WD PCNext


    //--------------------------------------------------------
    // 1) Program Counter
    //--------------------------------------------------------
    program_counter new_program_counter (
        .PC      (PC),
        .PCPlus4 (PCPlus4),
        .PCTarget(PCTarget),
        .ALUResult(ALUResult),
        .PCSrc   (PCSrc),
        .Reset   (Reset),
        .CLK     (CLK)
    );
    
    //--------------------------------------------------------
    // 2) Instruction Memory
    //--------------------------------------------------------
    instruction_memory new_instruction_memory (
        .Instr (Instr),
        .PC    (PC)
    );

    //--------------------------------------------------------
    // 3) Control Unit
    //--------------------------------------------------------
    control_unit new_control_unit (
        .PCSrc      (PCSrc),
        .ResultSrc  (ResultSrc),
        .MemWrite   (MemWrite),
        .ALUSrc     (ALUSrc),
        .RegWrite   (RegWrite),
        .ALUControl (ALUControl),
        .ImmSrc     (ImmSrc),
        .Instr      (Instr),
        .Zero       (Zero),
        .Negative   (Negative)
    );

    //--------------------------------------------------------
    // 4) Immediate Extension
    //--------------------------------------------------------
    extend new_extend (
        .ImmExt (ImmExt),
        .Instr  (Instr),
        .ImmSrc (ImmSrc)
    );

    //--------------------------------------------------------
    // 5) Register File
    //--------------------------------------------------------

    // Assign the register file inputs
    assign A1 = Instr[19:15];  // rs1
    assign A2 = Instr[24:20];  // rs2
    assign A3 = Instr[11:7];   // rd

    reg_file new_reg_file (
        .RD1  (RD1),
        .RD2  (RD2),
        .WD3  (WD3),               // Write-back data
        .A1   (A1),      // rs1
        .A2   (A2),      // rs2
        .A3   (A3),       // rd
        .WE3  (RegWrite),
        .CLK  (CLK)
    );

    //--------------------------------------------------------
    // 6) ALU
    //--------------------------------------------------------
    // ALU SrcA is always RD1
    assign SrcA = RD1;
    // ALU SrcB is either RD2 or the sign-extended immediate
    assign SrcB = (ALUSrc) ? ImmExt : RD2;

    alu new_alu (
        .ALUResult (ALUResult),
        .Zero      (Zero),
        .Negative  (Negative),
        .SrcA      (SrcA),
        .SrcB      (SrcB),
        .ALUControl(ALUControl)
    );

    //--------------------------------------------------------
    // 7) Data Memory + I/O
    //--------------------------------------------------------
    data_memory_and_io new_data_memory_and_io (
        .RD     (RD),
        .CPUOut (CPUOut),
        .A      (ALUResult),
        .WD     (RD2),        // Data to store comes from register file
        .CPUIn  (CPUIn),
        .WE     (MemWrite),
        .CLK    (CLK)
    );

    //--------------------------------------------------------
    // 8) Branch Target Adder
    //--------------------------------------------------------
    assign PCTarget = PC + ImmExt;  // For branches & jal

    //--------------------------------------------------------
    // 9) Result Mux (Write-back to Register File)
    //    ResultSrc chooses among:
    //      2'b00 -> ImmExt     (for LUI)
    //      2'b01 -> ALUResult  (R-type, I-type)
    //      2'b10 -> RD         (LW)
    //      2'b11 -> PCPlus4    (JAL, JALR)
    //--------------------------------------------------------

    always_comb begin
        case (ResultSrc)
            2'b00:  Result = ImmExt;     // LUI
            2'b01:  Result = ALUResult;  // R-type / I-type
            2'b10:  Result = RD;         // LW
            2'b11:  Result = PCPlus4;    // JAL, JALR
            default:Result = 32'd0;
        endcase
    end

    assign WD3 = Result; // Connect mux output to register file
endmodule


