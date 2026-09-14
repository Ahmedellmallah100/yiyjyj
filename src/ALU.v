module ALU (
    input  [6:0] SrcA,
    input  [6:0] SrcB,
    input  [2:0] ALUControl,
    output reg [6:0] ALuResult,
    output          zero_flag,
    output          sign_flag
);
    always @(*) begin
        case (ALUControl)
            3'b000: ALuResult = SrcA + SrcB;        // ADD
            3'b001: ALuResult = SrcA - SrcB;        // SUB
            3'b010: ALuResult = SrcA & SrcB;        // AND
            3'b011: ALuResult = SrcA | SrcB;        // OR
            3'b100: ALuResult = SrcA ^ SrcB;        // XOR
            3'b101: ALuResult = SrcA << SrcB[2:0];  // SLL
            3'b110: ALuResult = SrcA >> SrcB[2:0];  // SRL
            default: ALuResult = 7'b0;
        endcase
    end

    assign zero_flag = (ALuResult == 7'b0);
    assign sign_flag = ALuResult[6];
endmodule
