module Control_Unit (
    input  [3:0] opcode,
    output reg [2:0] ALUControl,
    output reg       ALUSrc,
    output reg       RegWrite,
    output reg       MemWrite,
    output reg       Branch,
    output reg       Jump,
    output reg       ResultSrc,
    output reg [1:0] ImmSrc
);
    // ISA:
    // 0 ADD, 1 SUB, 2 AND, 3 OR, 4 XOR, 5 SLL, 6 SRL
    // 7 ADDI, 8 LOAD, 9 STORE, A BEQ, B JMP

    always @(*) begin
        ALUControl = 3'b000;
        ALUSrc     = 1'b0;
        RegWrite   = 1'b0;
        MemWrite   = 1'b0;
        Branch     = 1'b0;
        Jump       = 1'b0;
        ResultSrc  = 1'b0;
        ImmSrc     = 2'b00;

        case (opcode)
            4'h0: begin ALUControl=3'b000; RegWrite=1'b1; end // ADD
            4'h1: begin ALUControl=3'b001; RegWrite=1'b1; end // SUB
            4'h2: begin ALUControl=3'b010; RegWrite=1'b1; end // AND
            4'h3: begin ALUControl=3'b011; RegWrite=1'b1; end // OR
            4'h4: begin ALUControl=3'b100; RegWrite=1'b1; end // XOR
            4'h5: begin ALUControl=3'b101; RegWrite=1'b1; end // SLL
            4'h6: begin ALUControl=3'b110; RegWrite=1'b1; end // SRL

            4'h7: begin // ADDI
                ALUControl=3'b000; ALUSrc=1'b1;
                RegWrite=1'b1; ImmSrc=2'b00;
            end
            4'h8: begin // LOAD
                ALUControl=3'b000; ALUSrc=1'b1;
                RegWrite=1'b1; ResultSrc=1'b1; ImmSrc=2'b00;
            end
            4'h9: begin // STORE
                ALUControl=3'b000; ALUSrc=1'b1;
                MemWrite=1'b1; ImmSrc=2'b01;
            end
            4'hA: begin // BEQ
                ALUControl=3'b001; Branch=1'b1; ImmSrc=2'b10;
            end
            4'hB: begin // JMP
                Jump=1'b1; ImmSrc=2'b11;
            end
            default: begin end
        endcase
    end
endmodule
