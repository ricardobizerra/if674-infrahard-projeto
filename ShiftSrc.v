module ShiftSrc(
    input [15:0] instruction150,
    input [31:0] B,
    input sel,
    output reg out[31:0]
);

always @* begin
    case (sel)
    1'b0: out = instruction150;
    1'b1: out = B;
    endcase
end
endmodule