module mux_shift_src(
    input [15:0] shamt,
    input [31:0] B,
    input sel,
    output reg [31:0] out
);

always @(sel) begin
    case (sel)
    1'b0: out = shamt[10:6];
    1'b1: out = B;
    endcase
end
endmodule