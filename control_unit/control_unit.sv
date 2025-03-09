module control_unit (output logic [1:0] PCSrc, 
                     output logic [1:0] ResultSrc,
                     output logic MemWrite, ALUSrc, RegWrite,
                     output logic [4:0] ALUControl,
                     output logic [2:0] ImmSrc,
                     input logic [31:0] Instr,
                     input logic Zero, Negative);

    logic [6:0] opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;
    
    assign opcode = Instr[6:0];     // Extract opcode
    assign funct3 = Instr[14:12];   // Extract funct3 field
    assign funct7 = Instr[31:25];   // Extract funct7 field

    always_comb begin
        // Default values
        PCSrc = 2'b00;
        ResultSrc = 2'b00;
        MemWrite = 0;
        ALUSrc = 0;
        RegWrite = 1;
        ALUControl = 5'b00000;
        ImmSrc = 3'b000;

        // Additional control signals based on instruction type
        case (opcode)
            7'b0110011: begin // R-type
                RegWrite = 1;
                ALUSrc = 0;
                MemWrite = 0;
                ResultSrc = 2'b01;
                PCSrc = 2'b00;
                ImmSrc = 3'b000;

                // Deciding the operations for the R-type instructions
                case (funct3)
                    3'b000: begin
                        case (funct7)
                            7'b0000000: ALUControl = 5'b00010; // add
                            7'b0100000: ALUControl = 5'b01010; // sub
                            default: ALUControl = 5'b00000;
                        endcase
                    end
                    3'b001: ALUControl = 5'b00000; // sll
                    3'b010: ALUControl = 5'b01001; // slt
                    3'b101: ALUControl = 5'b10000; // srl
                    3'b110: ALUControl = 5'b00111; // or
                    3'b111: ALUControl = 5'b00011; // and
                    default: ALUControl = 5'b00000;
                endcase
            end
        

            7'b0010011: begin // I-type
                RegWrite = 1;
                ALUSrc = 1;
                ImmSrc = 3'b000;
                MemWrite = 0;
                ResultSrc = 2'b01;
                PCSrc = 2'b00;
                
                case (funct3)
                    3'd0: ALUControl = 5'b00010; // addi
                    3'd1: ALUControl = 5'b00000; // slli
                    3'd2: ALUControl = 5'b01001; // slti
                    3'd5: ALUControl = 5'b10000; // srli
                    3'd6: ALUControl = 5'b00111; // ori
                    3'd7: ALUControl = 5'b00011; // andi
                    default: ALUControl = 5'b00000;
                endcase
            end

            7'b0000011: begin // lw
                RegWrite = 1;
                ALUSrc = 1;
                ImmSrc = 3'b000;
                MemWrite = 0;
                ResultSrc = 2'b10;
                ALUControl = 5'b00010; // Add for address calculation
                PCSrc = 2'b00;
            end

            7'b0100011: begin // sw
                RegWrite = 0;
                ALUSrc = 1;
                ImmSrc = 3'b001;
                MemWrite = 1;
                ALUControl = 5'b00010; // Add for address calculation
                PCSrc = 2'b00;
            end

            7'b1100011: begin // B-type
                RegWrite = 0;
                ALUSrc = 0;
                ImmSrc = 3'b010;
                MemWrite = 0;
                ResultSrc = 2'b00;

                case (funct3)
                    3'd0: begin // beq
                        PCSrc = Zero ? 2'b01 : 2'b00;
                        ALUControl = 5'b01010;;
                    end

                    3'd1: begin // bne
                        PCSrc = !Zero ? 2'b01 : 2'b00;
                        ALUControl = 5'b01010;
                    end

                    3'd4: begin
                        PCSrc = Negative ? 2'b01 : 2'b00; // blt
                        ALUControl = 5'b01001;
                    end

                    3'd5: begin
                        PCSrc = !Negative ? 2'b01 : 2'b00; // bge
                        ALUControl = 5'b01001;
                    end
                
                    default: PCSrc = 2'b00;
                endcase
            end


            7'b1101111: begin // jal
                RegWrite = 1;
                ALUSrc = 0;
                ImmSrc = 3'b100;
                MemWrite = 0;
                ResultSrc = 2'b11;
                PCSrc = 2'b01;
                ALUControl = 5'b00000; // Add for address calculation
            end


            7'b1100111: begin // jalr
                RegWrite = 1;
                ImmSrc = 3'b000;
                ALUSrc = 1;
                ALUControl = 5'b00010;
                PCSrc = 2'b10;
                ResultSrc = 2'b11; // Write PC+4 to register
                MemWrite = 0;
            end


            7'b0110111: begin // lui
                RegWrite = 1;
                ALUSrc = 0;
                ImmSrc = 3'b011;
                ResultSrc = 2'b00;
                MemWrite = 0;
                ALUControl = 5'b00010;
                PCSrc = 2'b00;
            end


            default: begin
                PCSrc = 2'b00;
                ResultSrc = 2'b00;
                MemWrite = 0;
                ALUSrc = 0;
                RegWrite = 0;
                ALUControl = 5'b00000;
                ImmSrc = 3'b000;
            end
        endcase
    end

endmodule
