module DivSrcA(
    input [31:0] A,
    input [31:0] dividendoOut,
    input sel,
    output reg out[31:0]
);

always @* begin
    case (sel)
    1'b0: out = A;
    1'b1: out = dividendoOut;
    endcase
end
endmodule