module AluSourceB(
    input [31:0] B,
    input [31:0] instructionExtended,
    input [31:0] instructionExtendedShiftLeft2,
    input [31:0] A,
    input [2:0] sel,
    output reg out[31:0]
);

always @* begin
    case (sel)
        3'b000: out = in[0];
        3'b001: out = 4;
        3'b010: out = instructionExtended;
        3'b011: out = instructionExtendedShiftLeft2;
        3'b100: out = A;
    endcase
end
endmodule