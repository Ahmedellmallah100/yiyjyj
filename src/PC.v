module PC (
    input        clk,
    input        areset,
    input  [4:0] PC_Next,
    output reg [4:0] PC
);
    always @(posedge clk or negedge areset) begin
        if (!areset)
            PC <= 5'b0;
        else
            PC <= PC_Next;
    end
endmodule
