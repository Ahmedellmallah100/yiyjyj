module Data_Memory #(
    parameter MEM_DEPTH = 8
)(
    input             clk,
    input             WE,
    input             areset,
    input      [6:0]  A,
    input      [6:0]  WD,
    output reg [6:0]  RD
);
    reg [6:0] mem [0:MEM_DEPTH-1];
    integer i;

    always @(*) begin
        RD = mem[A[2:0]];
    end

    always @(posedge clk or negedge areset) begin
        if (!areset) begin
            for (i = 0; i < MEM_DEPTH; i = i + 1)
                mem[i] <= 7'b0;
        end else if (WE) begin
            mem[A[2:0]] <= WD;
        end
    end
endmodule
