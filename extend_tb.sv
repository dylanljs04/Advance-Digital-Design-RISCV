`timescale 1ns/1ps // Define Time Units
`include "extend.sv" // Include the module under test

module extend_tb;

// Declare test variables
logic [31:0] t_Instr;
logic [2:0] t_ImmSrc;
logic [31:0] t_ImmExt;

// Instantiate the module under test (DUT)
extend dut(.ImmExt(t_ImmExt), .Instr(t_Instr), .ImmSrc(t_ImmSrc));

initial begin
    // Create a waveform dump file for GTKWave analysis
    $dumpfile("extend_tb.vcd"); 
    $dumpvars(0, extend_tb);
    
    // Test Vectors
    $display("Starting Immediate Extension Tests...");

    // Test Case 1: I-type Immediate (addi, andi, ori)
    t_Instr = 32'hFEDCBA98; // Example instruction
    t_ImmSrc = 3'b000;
    #5;
    $display("I-type Immediate: Instr = %h, ImmSrc = %b, ImmExt = %h", t_Instr, t_ImmSrc, t_ImmExt);

    // Test Case 2: S-type Immediate (sw)
    t_Instr = 32'hA5A5A5A5;
    t_ImmSrc = 3'b001;
    #5;
    $display("S-type Immediate: Instr = %h, ImmSrc = %b, ImmExt = %h", t_Instr, t_ImmSrc, t_ImmExt);

    // Test Case 3: B-type Immediate (beq, bne, blt, bge)
    t_Instr = 32'h12345678;
    t_ImmSrc = 3'b010;
    #5;
    $display("B-type Immediate: Instr = %h, ImmSrc = %b, ImmExt = %h", t_Instr, t_ImmSrc, t_ImmExt);

    // Test Case 4: U-type Immediate (lui)
    t_Instr = 32'hABCDEF12;
    t_ImmSrc = 3'b011;
    #5;
    $display("U-type Immediate: Instr = %h, ImmSrc = %b, ImmExt = %h", t_Instr, t_ImmSrc, t_ImmExt);

    // Test Case 5: J-type Immediate (jal)
    t_Instr = 32'h98765432;
    t_ImmSrc = 3'b100;
    #5;
    $display("J-type Immediate: Instr = %h, ImmSrc = %b, ImmExt = %h", t_Instr, t_ImmSrc, t_ImmExt);

    $display("All tests completed.");
    #10;
    $finish;
end

// Monitor changes in signals
initial begin
    $monitor("Time = %3d, Instr = %h, ImmSrc = %b, ImmExt = %h",
             $time, t_Instr, t_ImmSrc, t_ImmExt);
end

endmodule
