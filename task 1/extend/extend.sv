module extend (output logic [31:0] ImmExt,
                input logic [31:0] Instr,
                input logic [2:0] ImmSrc);

logic [31:0] imm_i, imm_s, imm_b, imm_u, imm_j;

assign imm_i = {{20{Instr[31]}}, Instr[31:20]};
assign imm_s = {{20{Instr[31]}}, Instr[31:25], Instr[11:7]};
assign imm_b = {{19{Instr[31]}}, Instr[31], Instr[7], Instr[30:25], Instr[11:8], 1'b0};
assign imm_u = {Instr[31:12], 12'b0};
assign imm_j = {{12{Instr[31]}}, Instr[19:12], Instr[20], Instr[30:21], 1'b0};

always_comb begin
    case (ImmSrc)
        3'b000: ImmExt = imm_i;
        3'b001: ImmExt = imm_s;
        3'b010: ImmExt = imm_b;
        3'b011: ImmExt = imm_u;
        3'b100: ImmExt = imm_j;
        default: ImmExt = 32'b0;
    endcase
end

endmodule