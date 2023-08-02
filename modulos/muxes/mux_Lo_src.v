module Lo_src(
    input [31:0] DIV_min,
    input [31:0] MULT_min,
    input sel,
    output reg [31:0] out
);

always @* begin
    case (sel)
    1'b0: out = DIV_min;
    1'b1: out = MULT_min;
    endcase
end
endmodule