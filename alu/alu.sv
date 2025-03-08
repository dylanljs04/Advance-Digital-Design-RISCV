module alu (output logic signed [31:0] ALUResult,
            output logic Zero, Negative,
            input logic signed [31:0] SrcA, SrcB,
            input logic [4:0] ALUControl);

logic carry_in;
logic zero_buffer, negative_buffer;
logic [1:0] ALUOp;
logic [31:0] shiftResult, sltResult, arithResult, logicResult;

// Extract Operation code for ALU multiplexer
assign ALUOp = ALUControl[1:0];

// Shfift Operations
assign shiftResult = (ALUControl[4]) ? SrcA >> SrcB[4:0] : SrcA << SrcB[4:0];

// SLT and Airthmetic operations
assign arithResult = (ALUControl[3]) ? SrcA - SrcB : SrcA + SrcB;
assign sltResult = (arithResult[31]) ? 32'd1 : 32'd0;


// Logic Operations
assign logicResult = (ALUControl[2]) ? (SrcA | SrcB) : (SrcA & SrcB);

// Zero and Negative
assign zero_buffer = (ALUResult == 32'd0) ? 1 : 0;
assign negative_buffer = (ALUResult[31]) ? 1 : 0;

always_comb
     begin
          case (ALUOp)
               2'b00: ALUResult = shiftResult;
               2'b01: ALUResult = sltResult;
               2'b10: ALUResult = arithResult;
               2'b11: ALUResult = logicResult;
               default: ALUResult = 32'd0;
          endcase

          Zero = zero_buffer;
          Negative = negative_buffer;
     end



endmodule