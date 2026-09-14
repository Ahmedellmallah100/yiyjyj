module Instruction_memory #(
    parameter MEM_WIDTH = 16,
    parameter MEM_DEPTH = 32
)(
    input  [4:0]  A,
    output [15:0] RD
);
    reg [MEM_WIDTH-1:0] mem [0:MEM_DEPTH-1];

    assign RD = mem[A];

    initial begin
        $readmemh("program.txt", mem);
    end
endmodule
