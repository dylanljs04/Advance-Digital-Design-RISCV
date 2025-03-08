`timescale 1ns/1ps // Define Time Units
`include "alu.sv" // Include the module under test

module alu_tb;

// Declare test variables
logic signed [31:0] t_SrcA, t_SrcB, t_ALUResult;
logic [4:0] t_ALUControl;
logic t_Zero, t_Negative;

// Instantiate the module under test (DUT)
alu dut(
    .ALUResult(t_ALUResult),
    .Zero(t_Zero),
    .Negative(t_Negative),
    .SrcA(t_SrcA),
    .SrcB(t_SrcB),
    .ALUControl(t_ALUControl)
);

initial begin
    // Create a waveform dump file for GTKWave analysis
    $dumpfile("alu_tb.vcd"); 
    $dumpvars(0, alu_tb);
    
    // Test Vectors
    $display("Starting ALU Tests...");

    // Test Case 1: Left Shift (ALUControl[1:0]=00, ALUControl[4]=0)
    t_SrcA = 32'h000000F0;
    t_SrcB = 32'h00000004; // Shift left by 4 bits
    t_ALUControl = 5'b00000;
    #5;
    $display("Time = %3d, Left Shift: SrcA = %h, SrcB = %h, ALUControl = %b, ALUResult = %h, Zero = %b, Negative = %b", 
             $time, t_SrcA, t_SrcB, t_ALUControl, t_ALUResult, t_Zero, t_Negative);

    // Test Case 2: Right Shift (ALUControl[1:0]=00, ALUControl[4]=1)
    t_SrcA = 32'h0000000F;
    t_SrcB = 32'h00000004; // Shift Right by 4 bits
    t_ALUControl = 5'b10000;
    #5;
    $display("Time = %3d, Right Shift: SrcA = %h, SrcB = %h, ALUControl = %b, ALUResult = %h, Zero = %b, Negative = %b", 
             $time, t_SrcA, t_SrcB, t_ALUControl, t_ALUResult, t_Zero, t_Negative);

    // Test Case 3: SLT with SrcA < SrcB (ALUControl[1:0]=01)
    t_SrcA = 32'hFFFFFFFF; // -1 in 2's complement
    t_SrcB = 32'h00000001; // 1
    t_ALUControl = 5'b01001;
    #5;
    $display("Time = %3d, SLT (A<B): SrcA = %d, SrcB = %d, ALUControl = %b, ALUResult = %h, Zero = %b, Negative = %b", 
             $time, t_SrcA, t_SrcB, t_ALUControl, t_ALUResult, t_Zero, t_Negative);

    // Test Case 4: SLT with SrcA > SrcB (ALUControl[1:0]=01)
    t_SrcA = 32'h00000005; // 5
    t_SrcB = 32'h00000002; // 2
    t_ALUControl = 5'b01001;
    #5;
    $display("Time = %3d, SLT (A>B): SrcA = %d, SrcB = %d, ALUControl = %b, ALUResult = %h, Zero = %b, Negative = %b", 
             $time, t_SrcA, t_SrcB, t_ALUControl, t_ALUResult, t_Zero, t_Negative);

    // Test Case 5: Addition (ALUControl[1:0]=10, ALUControl[3]=0)
    t_SrcA = 32'h00000007; // 7
    t_SrcB = 32'h00000003; // 3
    t_ALUControl = 5'b00010;
    #5;
    $display("Time = %3d, Addition: SrcA = %d, SrcB = %d, ALUControl = %b, ALUResult = %d, Zero = %b, Negative = %b", 
             $time, t_SrcA, t_SrcB, t_ALUControl, t_ALUResult, t_Zero, t_Negative);

    // Test Case 6: Subtraction (ALUControl[1:0]=10, ALUControl[3]=1)
    t_SrcA = 32'h00000005; // 5
    t_SrcB = 32'h00000008; // 8
    t_ALUControl = 5'b01010;
    #5;
    $display("Time = %3d, Subtraction: SrcA = %d, SrcB = %d, ALUControl = %b, ALUResult = %d, Zero = %b, Negative = %b", 
             $time, t_SrcA, t_SrcB, t_ALUControl, t_ALUResult, t_Zero, t_Negative);

        // Test Case 6: Subtraction (ALUControl[1:0]=10, ALUControl[3]=1) where result is a negative value
    t_SrcA = 32'h00000008; // 5
    t_SrcB = 32'h00000005; // 8
    t_ALUControl = 5'b01010;
    #5;
    $display("Time = %3d, Subtraction: SrcA = %d, SrcB = %d, ALUControl = %b, ALUResult = %d, Zero = %b, Negative = %b", 
             $time, t_SrcA, t_SrcB, t_ALUControl, t_ALUResult, t_Zero, t_Negative);

    // Test Case 7: AND operation (ALUControl[1:0]=11, ALUControl[2]=0)
    t_SrcA = 32'hFF00FF00;
    t_SrcB = 32'h0F0F0F0F;
    t_ALUControl = 5'b00011;
    #5;
    $display("Time = %3d, AND: SrcA = %h, SrcB = %h, ALUControl = %b, ALUResult = %h, Zero = %b, Negative = %b", 
             $time, t_SrcA, t_SrcB, t_ALUControl, t_ALUResult, t_Zero, t_Negative);

    // Test Case 8: OR operation (ALUControl[1:0]=11, ALUControl[2]=1)
    t_SrcA = 32'hF0F0F0F0;
    t_SrcB = 32'h0F0F0FF0;
    t_ALUControl = 5'b00111;
    #5;
    $display("Time = %3d, OR: SrcA = %h, SrcB = %h, ALUControl = %b, ALUResult = %h, Zero = %b, Negative = %b", 
             $time, t_SrcA, t_SrcB, t_ALUControl, t_ALUResult, t_Zero, t_Negative);

    // Test Case 9: Zero flag test (subtract equal values)
    t_SrcA = 32'h00000010; // 16
    t_SrcB = 32'h00000010; // 16
    t_ALUControl = 5'b01010; // Subtraction
    #5;
    $display("Time = %3d, Zero Flag Test: SrcA = %d, SrcB = %d, ALUControl = %b, ALUResult = %d, Zero = %b, Negative = %b", 
             $time, t_SrcA, t_SrcB, t_ALUControl, t_ALUResult, t_Zero, t_Negative);

    $display("All tests completed.");
    #10;
    $finish;
end

// Monitor changes in signals
// initial begin
//     $monitor("Time = %3d, SrcA = %h, SrcB = %h, ALUControl = %b, ALUResult = %h, Zero = %b, Negative = %b",
//              $time, t_SrcA, t_SrcB, t_ALUControl, t_ALUResult, t_Zero, t_Negative);
// end

endmodule