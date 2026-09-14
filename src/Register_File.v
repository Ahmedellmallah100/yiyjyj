module Register_File #(
    parameter MEM_WIDTH = 7,
    parameter MEM_DEPTH = 8
)(
    input             clk,
    input             areset,
    input      [2:0]  A1,
    input      [2:0]  A2,
    input      [2:0]  A3,
    input      [6:0]  WD3,
    input             WE3,
    output reg [6:0]  RD1,
    output reg [6:0]  RD2
);
    reg [MEM_WIDTH-1:0] mem [0:MEM_DEPTH-1];
    integer i;

    always @(*) begin
        RD1 = (A1 == 3'b000) ? 7'b0 : mem[A1];
        RD2 = (A2 == 3'b000) ? 7'b0 : mem[A2];
    end

    always @(posedge clk or negedge areset) begin
        if (!areset) begin
            for (i = 0; i < MEM_DEPTH; i = i + 1)
                mem[i] <= 7'b0;
        end else if (WE3 && (A3 != 3'b000)) begin
            mem[A3] <= WD3;
        end
    end
endmodule
