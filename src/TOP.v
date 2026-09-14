module TOP (
    input clk,
    input areset
);
    wire [4:0]  PC, PC_Next;
    wire [15:0] Instr;

    wire [2:0] ALUControl;
    wire       ALUSrc, RegWrite, MemWrite, Branch, Jump, ResultSrc;
    wire [1:0] ImmSrc;

    wire [6:0] SrcA, SrcB, SrcB_reg;
    wire [6:0] ALuResult, ImmExt, RD, Result;
    wire       Zero;

    wire [3:0] opcode = Instr[15:12];

    PC pc_inst (
        .clk(clk), .areset(areset),
        .PC_Next(PC_Next), .PC(PC)
    );

    Instruction_memory im_inst (
        .A(PC), .RD(Instr)
    );

    Control_Unit cu_inst (
        .opcode(opcode),
        .ALUControl(ALUControl),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .MemWrite(MemWrite),
        .Branch(Branch),
        .Jump(Jump),
        .ResultSrc(ResultSrc),
        .ImmSrc(ImmSrc)
    );

    Sign_extend se_inst (
        .Instr(Instr),
        .ImmSrc(ImmSrc),
        .ImmExt(ImmExt)
    );

    // R-type: rd[11:9], rs1[8:6], rs2[5:3]
    // I-type: rd[11:9], rs1[8:6], imm[5:0]
    // STORE:  rs1[11:9], rs2[8:6], imm[5:0]
    // BEQ:    rs1[11:9], rs2[8:6], off[5:0]
    Register_File rf_inst (
        .clk(clk), .areset(areset),
        .A1(Instr[8:6]),
        .A2((opcode == 4'h9 || opcode == 4'hA) ? Instr[8:6] : Instr[5:3]),
        .A3(Instr[11:9]),
        .WD3(Result),
        .WE3(RegWrite),
        .RD1(SrcA),
        .RD2(SrcB_reg)
    );

    Mux #(.WIDTH(7)) alu_mux (
        .in0(SrcB_reg),
        .in1(ImmExt),
        .sel(ALUSrc),
        .out(SrcB)
    );

    ALU alu_inst (
        .ALUControl(ALUControl),
        .SrcA(SrcA),
        .SrcB(SrcB),
        .ALuResult(ALuResult),
        .zero_flag(Zero),
        .sign_flag()
    );

    Data_Memory dm_inst (
        .clk(clk), .WE(MemWrite), .areset(areset),
        .A(ALuResult), .WD(SrcB_reg), .RD(RD)
    );

    Mux #(.WIDTH(7)) result_mux (
        .in0(ALuResult),
        .in1(RD),
        .sel(ResultSrc),
        .out(Result)
    );

    // PC is instruction-indexed: +1 per instruction.
    // BEQ uses a signed 6-bit relative offset.
    // JMP uses an absolute 5-bit target.
    reg [4:0] branch_target;
    reg [4:0] seq_pc;

    always @(*) begin
        seq_pc = PC + 5'd1;
        branch_target = PC + ImmExt[4:0];

        if (Jump)
            PC_Next = Instr[4:0];
        else if (Branch && Zero)
            PC_Next = branch_target;
        else
            PC_Next = seq_pc;
    end
endmodule
