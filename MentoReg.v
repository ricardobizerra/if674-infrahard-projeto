module MentoReg (
    input [6:0][31:0] in,
    input [3:0] sel,
    output reg out[31:0]
);

always @* begin
    case (sel)
        4'b0000: out = in[0];
        4'b0001: out = in[1];
        4'b0010: out = in[2];
        4'b0011: out = in[3];
        4'b0100: out = 227;
        4'b0101: out = 0;
        4'b0110: out = 1;
        4'b0111: out = in[7];
        4'b1000: out = in[8];
    endcase
end
endmodule
