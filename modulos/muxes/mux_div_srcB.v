module mux_div_srcB(
    input wire [31:0] B,
    input wire [31:0] divisorOut,
    input wire sel,
    output reg [31:0] out
);

always @* begin
    case (sel)
    1'b0: out = B;
    1'b1: out = divisorOut;
    endcase
end
endmodule