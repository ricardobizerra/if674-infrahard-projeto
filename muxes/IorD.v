module IorD (
    input [31:0] PC,
    input [31:0] AluOut,
    input [31:0] Except,
    input [31:0] A,
    input [31:0] B,
    input [2:0] sel,
    output reg [31:0] out
);

always @* begin
    case (sel)
        3'b000: out = PC;
        3'b001: out = AluOut;
        3'b010: out = Except;
        3'b011: out = A;
        3'b100: out = B;
    endcase
end
endmodule
