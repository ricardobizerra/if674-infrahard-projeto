module mux_div_srcA(
    input wire [31:0] A,
    input wire [31:0] dividendoOut,
    input wire sel,
    output reg [31:0] out
);

always @* begin
    case (sel)
    1'b0: out = A;
    1'b1: out = dividendoOut;
    endcase
end
endmodule