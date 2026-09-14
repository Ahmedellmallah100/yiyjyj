module Sign_extend (
    input      [15:0] Instr,
    input      [1:0]  ImmSrc,
    output reg [6:0]  ImmExt
);
    always @(*) begin
        case (ImmSrc)
            2'b00: ImmExt = {{1{Instr[5]}}, Instr[5:0]}; // I-type: 6-bit signed
            2'b01: ImmExt = {{1{Instr[5]}}, Instr[5:0]}; // S-type: 6-bit signed
            2'b10: ImmExt = {{1{Instr[5]}}, Instr[5:0]}; // B-type: signed PC offset
            2'b11: ImmExt = {2'b00, Instr[4:0]};         // J-type: absolute 5-bit target
            default: ImmExt = 7'b0;
        endcase
    end
endmodule
