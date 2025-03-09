`timescale 1ns/1ps
`include "control_unit.sv"

module control_unit_tb;

// Declare test variables
logic [31:0] t_Instr;
logic t_Zero, t_Negative;
logic [1:0] t_PCSrc, t_ResultSrc;
logic t_MemWrite, t_ALUSrc, t_RegWrite;
logic [4:0] t_ALUControl;
logic [2:0] t_ImmSrc;
// string test_name = "HI";

// Instantiate the module under test (DUT)
control_unit dut(
    .PCSrc(t_PCSrc),
    .ResultSrc(t_ResultSrc),
    .MemWrite(t_MemWrite),
    .ALUSrc(t_ALUSrc),
    .RegWrite(t_RegWrite),
    .ALUControl(t_ALUControl),
    .ImmSrc(t_ImmSrc),
    .Instr(t_Instr),
    .Zero(t_Zero),
    .Negative(t_Negative)
);

// Helper function to display test results
function void display_test(string test_name);
    $display("Time = %3d, Test: %s", $time, test_name);
    $display("  Instr = %8h, Zero = %b, Negative = %b", t_Instr, t_Zero, t_Negative);
    $display("  PCSrc = %b, ResultSrc = %b, MemWrite = %b, ALUSrc = %b, RegWrite = %b", 
              t_PCSrc, t_ResultSrc, t_MemWrite, t_ALUSrc, t_RegWrite);
    $display("  ALUControl = %5b, ImmSrc = %3b", t_ALUControl, t_ImmSrc);
endfunction

initial begin
    // Create a waveform dump file for GTKWave analysis
    $dumpfile("control_unit_tb.vcd");
    $dumpvars(0, control_unit_tb);
    
    // Initialize test inputs
    t_Instr = 32'h00000000;
    t_Zero = 0;
    t_Negative = 0;
    #5;
    
    $display("Starting Control Unit Tests...");

    // Test Case 1: R-type ADD (opcode=0110011, funct3=000, funct7=0000000)
    $display("R-type ADD");
    t_Instr = 32'h00000033; // add x0, x0, x0
    #5;
    
    // Test Case 2: R-type SUB (opcode=0110011, funct3=000, funct7=0100000)
    $display("R-type SUB");
    t_Instr = 32'h40000033; // sub x0, x0, x0
    #5;
    // display_test("R-type SUB");
    
    // Test Case 3: R-type OR (opcode=0110011, funct3=110, funct7=0000000)
    $display("R-type OR");
    t_Instr = 32'h00006033; // or x0, x0, x0
    #5;
    // display_test("R-type OR");
    
    // Test Case 4: R-type AND (opcode=0110011, funct3=111, funct7=0000000)
    $display("R-type AND");
    t_Instr = 32'h00007033; // and x0, x0, x0
    #5;
    // display_test("R-type AND");
    
    // Test Case 5: R-type SLL (opcode=0110011, funct3=001, funct7=0000000)
    $display("R-type SLL");
    t_Instr = 32'h00001033; // sll x0, x0, x0
    #5;
    // display_test("R-type SLL");
    
    // Test Case 6: R-type SLT (opcode=0110011, funct3=010, funct7=0000000)
    $display("R-type SLT");
    t_Instr = 32'h00002033; // slt x0, x0, x0
    #5;
    // display_test("R-type SLT");
    
    // Test Case 7: R-type SRL (opcode=0110011, funct3=101, funct7=0000000)
    $display("R-type SRL");
    t_Instr = 32'h00005033; // srl x0, x0, x0
    #5;
    // display_test("R-type SRL");
    
    // Test Case 8: I-type ADDI (opcode=0010011, funct3=000)
    $display("I-type ADDI");
    t_Instr = 32'h00000013; // addi x0, x0, 0
    #5;
    // display_test("I-type ADDI");
    
    // Test Case 9: I-type SLLI (opcode=0010011, funct3=001)
    $display("I-type SLLI");
    t_Instr = 32'h00001013; // slli x0, x0, 0
    #5;
    // display_test("I-type SLLI");
    
    // Test Case 10: I-type SLTI (opcode=0010011, funct3=010)
    $display("I-type SLTI");
    t_Instr = 32'h00002013; // slti x0, x0, 0
    #5;
    // display_test("I-type SLTI");
    
    // Test Case 11: I-type SRLI (opcode=0010011, funct3=101)
    $display("I-type SRLI");
    t_Instr = 32'h00005013; // srli x0, x0, 0
    #5;
    // display_test("I-type SRLI");
    
    // Test Case 12: I-type ORI (opcode=0010011, funct3=110)
    $display("I-type ORI");
    t_Instr = 32'h00006013; // ori x0, x0, 0
    #5;
    // display_test("I-type ORI");
    
    // Test Case 13: I-type ANDI (opcode=0010011, funct3=111)
    $display("I-type ANDI");
    t_Instr = 32'h00007013; // andi x0, x0, 0
    #5;
    // display_test("I-type ANDI");
    
    // Test Case 14: I-type LW (opcode=0000011)
    $display("I-type LW");
    t_Instr = 32'h00000003; // lw x0, 0(x0)
    #5;
    // display_test("I-type LW");
    
    // Test Case 15: S-type SW (opcode=0100011)
    $display("S-type SW");
    t_Instr = 32'h00000023; // sw x0, 0(x0)
    #5;
    // display_test("S-type SW");

    
    // // Test Case 16a: B-type BEQ with Zero=1 (opcode=1100011, funct3=000)
    $display("B-type BEQ with Zero=1");
    t_Instr = 32'h00000063; // beq x0, x0, 0
    t_Zero = 1;
    t_Negative = 0;
    #5;

    // Test Case 16b: B-type BEQ with Zero=0 (opcode=1100011, funct3=000)
    $display("B-type BEQ with Zero=0");
    t_Instr = 32'h00000063; // beq x0, x0, 0
    t_Zero = 0;
    t_Negative = 0;
    #5;

    // Test Case 17a: B-type BEQ with Zero=1 (opcode=1100011, funct3=000)
    $display("B-type BNE wit Zero=1");
    t_Instr = 32'h00001063; // beq x0, x0, 0
    t_Zero = 1;
    t_Negative = 0;
    #5;

    // Test Case 17b: B-type BEQ with Zero=0 (opcode=1100011, funct3=000)
    $display("B-type BNE wit Zero=0");
    t_Instr = 32'h00001063; // beq x0, x0, 0
    t_Zero = 0;
    t_Negative = 0;
    #5;

    // // Test Case 18a: B-type BEQ with Zero=1 (opcode=1100011, funct3=000)
    $display("B-type BLT with Negative=1");
    t_Instr = 32'h00004063; // beq x0, x0, 0
    t_Zero = 0;
    t_Negative = 1;
    #5;
    
    // // Test Case 18b: B-type BEQ with Zero=1 (opcode=1100011, funct3=000)
    $display("B-type BLT with Negative=0");
    t_Instr = 32'h00004063; // beq x0, x0, 0
    t_Zero = 0;
    t_Negative = 0;
    #5;

    // // Test Case 19a: B-type BEQ with Zero=1 (opcode=1100011, funct3=000)
    $display("B-type BGE with Negative=1");
    t_Instr = 32'h00005063; // beq x0, x0, 0
    t_Zero = 0;
    t_Negative = 1;
    #5;

    // // Test Case 19b: B-type BEQ with Zero=1 (opcode=1100011, funct3=000)
    $display("B-type BGE with Negative=0");
    t_Instr = 32'h00005063; // beq x0, x0, 0
    t_Zero = 0;
    t_Negative = 0;
    #5;
    
    // Test Case 20: J-type JAL (opcode=1101111)
    $display("J-type JAL");
    t_Instr = 32'h0000006f; // jal x0, 0
    t_Zero = 0;
    t_Negative = 0;
    #5;
    // display_test("J-type JAL");
    
    // Test Case 21: I-type JALR (opcode=1100111)
    $display("I-type JALR");
    t_Instr = 32'h00000067; // jalr x0, 0(x0)
    #5;
    // display_test("I-type JALR");
    
    // Test Case 22: U-type LUI (opcode=0110111)
    $display("U-type LUI");
    t_Instr = 32'h00000037; // lui x0, 0
    #5;
    // display_test("U-type LUI");
    
    // Test Case 23: Default case (invalid opcode)
    $display("Invalid instruction");
    t_Instr = 32'h00000000; // Invalid opcode
    #5;
    // display_test("Invalid instruction");
    
    $display("All tests completed.");
    #10;
    $finish;
end

initial begin
    // $monitor("Time = %3d, Test: %s", $time, "test_name");
    // $monitor("  Instr = %8h, Zero = %b, Negative = %b", t_Instr, t_Zero, t_Negative);
    // $monitor("  PCSrc = %b, ResultSrc = %b, MemWrite = %b, ALUSrc = %b, RegWrite = %b", 
    //           t_PCSrc, t_ResultSrc, t_MemWrite, t_ALUSrc, t_RegWrite);
    // $monitor("  ALUControl = %5b, ImmSrc = %3b", t_ALUControl, t_ImmSrc);

    $monitor("Time = %3d, Instr = %8h, Zero = %b, Negative = %b, RegWrite = %b, ImmSrc = %3b, ALUSrc = %b, ALUControl = %5b, MemWrite = %b, ResultSrc = %b, PCSrc = %b", 
             $time, t_Instr, t_Zero, t_Negative, t_RegWrite, t_ImmSrc, t_ALUSrc, t_ALUControl, t_MemWrite, t_ResultSrc, t_PCSrc);
end

// Itype ori is wrin: 00011 instead of XX111

endmodule