module AluSourceB(
    input [31:0] B,
    input [31:0] instructionExtended,
    input [31:0] instructionExtendedShiftLeft2,
    input [31:0] A,
    input [2:0] sel,
    output reg [31:0] out
);

always @(sel) begin
    case (sel)
        3'b000: out = B;
        3'b001: out = 32'b00000000000000000000000000000100; // 4
        3'b010: out = instructionExtended;
        3'b011: out = instructionExtendedShiftLeft2;
        3'b100: out = A;
    endcase
end
endmodule