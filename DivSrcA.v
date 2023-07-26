module DivSrcA(
    input [1:0][31:0] in,
    input sel,
    output reg out[31:0]
);

always @* begin
    case (sel)
    1'b0: out = in[0];
    1'b1: out = in[1];
    endcase
end
endmodule