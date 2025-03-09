`timescale 1ns/1ps  // Define Time Units
`include "program_counter.sv"  // Include the module under test

module program_counter_tb;

// Declare test variables
logic [31:0] t_PC, t_PCPlus4, t_PCTarget, t_ALUResult;
logic [1:0] t_PCSrc;
logic t_Reset, t_CLK;

// Instantiate the module under test (DUT)
program_counter dut(
    .PC(t_PC),
    .PCPlus4(t_PCPlus4),
    .PCTarget(t_PCTarget),
    .ALUResult(t_ALUResult),
    .PCSrc(t_PCSrc),
    .Reset(t_Reset),
    .CLK(t_CLK)
);

// sets the clock
initial begin
    t_CLK = 1;
    // Loop for t_CLK
    for (int i = 0; i < 40; i++) begin
        #5 t_CLK = ~t_CLK;
    end
end

initial begin
    // Create a waveform dump file for GTKWave analysis
    $dumpfile("program_counter_tb.vcd"); 
    $dumpvars(0, program_counter_tb);
    
    t_PCSrc = 2'b00;  // Default to normal execution
    t_Reset = 1;  // Apply reset
    #10;
    t_Reset = 0;  // Release reset
    #10;

    $display("Starting Program Counter Tests...");

    // Test Case 1: Normal Execution (PCSrc = 00, PC increments by 4)
    $display("Normal Execution: PC increments by 4");
    t_PCSrc = 2'b00;
    #40;

    // Test Case 2: Branch Taken (PCSrc = 01, PC = PCTarget)
    $display("Branch Taken: PC = PCTarget");
    t_PCTarget = 32'h00000050; // Example branch target
    t_PCSrc = 2'b01;
    #10;
    t_PCSrc = 2'b00;  // Reset to normal execution
    #30;

    $display("Jump: PC = ALUResult");
    // Test Case 3: Jump (PCSrc = 10, PC = ALUResult)
    t_ALUResult = 32'h00000100; // Example jump target
    t_PCSrc = 2'b10;
    #10;
    t_PCSrc = 2'b00;  // Reset to normal execution
    #20

    $display("Reset the counter to 0");
    // Test Case 4: Reset Condition
    t_Reset = 1;
    #10;
    t_Reset = 0;
    #10;

    $finish;
end

// Generate Clock Signal
// always #5 t_CLK = ~t_CLK;  // Toggle clock every 5ns

// Monitor changes in signals
initial begin
    $monitor("Time = %3d, PCSrc = %b, PC = %h, PCPlus4 = %h, PCTarget = %h, ALUResult = %h, Reset = %b", 
             $time, t_PCSrc, t_PC, t_PCPlus4, t_PCTarget, t_ALUResult, t_Reset);
end

endmodule
