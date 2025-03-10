// `timescale 1ns/1ps
// `include "risc_v.sv"

// module risc_v_tb;
// logic [31:0] CPUOut, CPUIn;
// logic Reset, CLK;

// risc_v dut(CPUOut, CPUIn, Reset, CLK);

// initial begin // Generate clock signal with 20 ns period
// CLK = 0;
// forever #10 CLK = ~CLK;
// end

// initial begin // Apply stimulus

// $dumpfile("risc_v_tb.vcd");
// $dumpvars(0, risc_v_tb);

// $finish; // This system tasks ends the simulation
// end

// always @ (negedge CLK)
// $display ("t = %3d, CPUIn = %d, CPUOut = %d, Reset = %b, PCSrc = %b PC = %d, PCTarget = %h, ImmExt = %h, Instr = %h, ALUResult = %d", $time, CPUIn, CPUOut, Reset, dut.PCSrc, dut.PC, dut.PCTarget, dut.ImmExt, dut.Instr, dut.ALUResult);

// endmodule



`timescale 1ns/1ps
`include "risc_v.sv"

module risc_v_tb;
  // Declare signals
  logic [31:0] CPUOut, CPUIn;
  logic Reset, CLK;
  
  // Instantiate the DUT
  risc_v dut(CPUOut, CPUIn, Reset, CLK);
  
  // Generate clock signal with 20 ns period
  initial begin
    CLK = 0;
    forever #5 CLK = ~CLK;
  end
  
  // Apply stimulus and generate dump file for GTKWave
  initial begin
    // Dump file and variables for GTKWave
    $dumpfile("risc_v_tb.vcd");
    $dumpvars(0, risc_v_tb);
    
    // Initialize inputs
    Reset = 1;
    CPUIn = 32'h00000000;  // Default value; adjust as necessary
    
    // Hold reset for 20 ns, then release
    #10;
    Reset = 0;
    
    // Let simulation run for additional time to observe behavior
    #400;
    
    $finish;  // End simulation
  end


  // Display selected signals at every negative clock edge
  always @(negedge CLK)
    $display("t = %3d, CPUIn = %d, CPUOut = %d, Reset = %b, PCSrc = %b, PC = %d, PCTarget = %h, ImmExt = %h, Instr = %h, ALUResult = %d", 
             $time, CPUIn, CPUOut, Reset, dut.PCSrc, dut.PC, dut.PCTarget, dut.ImmExt, dut.Instr, dut.ALUResult);

endmodule