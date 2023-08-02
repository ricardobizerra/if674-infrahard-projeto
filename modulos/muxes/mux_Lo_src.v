module Lo_src(
    input wire [31:0] DIV_min,
    input wire [31:0] MULT_min,
    input wire sel,
    output reg [31:0] out
);

always @* begin
    case (sel)
    1'b0: out = DIV_min;
    1'b1: out = MULT_min;
    endcase
end
endmodule