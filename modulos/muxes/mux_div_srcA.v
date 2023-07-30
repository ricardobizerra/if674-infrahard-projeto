module mux_div_srcA(
    input [31:0] A,
    input [31:0] dividendoOut,
    input sel,
    output reg [31:0] out
);

always @(sel) begin
    case (sel)
    1'b0: out = A;
    1'b1: out = dividendoOut;
    endcase
end
endmodule