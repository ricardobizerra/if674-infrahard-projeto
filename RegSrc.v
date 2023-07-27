module RegSrc (
    input [31:00]in,
    input sel,
    output reg in_divisor[31:0],
    output reg in_dividendo[31:0]
);

always @* begin
    case (sel)
        1'b0: in_dividendo = in;
        1'b1: in_divisor = in;
    endcase
end
endmodule
