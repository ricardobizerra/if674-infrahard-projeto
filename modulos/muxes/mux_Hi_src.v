module Hi_src(
    input wire [31:0] DIV_max,
    input wire [31:0] MULT_max,
    input wire sel,
    output reg [31:0] out
);

always @* begin
    case (sel)
    1'b0: out = DIV_max;
    1'b1: out = MULT_max;
    endcase
end
endmodule