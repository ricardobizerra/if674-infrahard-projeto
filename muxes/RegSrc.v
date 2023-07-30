module RegSrc (
    input [31:0]in,
    input sel,
    output reg [31:0] in_divisor,
    output reg [31:0] in_dividendo
);

always @(sel) begin
    case (sel)
        1'b0: in_dividendo = in;
        1'b1: in_divisor = in;
    endcase
end
endmodule
