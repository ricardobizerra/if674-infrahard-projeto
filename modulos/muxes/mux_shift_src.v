module mux_shift_src(
    input wire [15:0] immediate,
    input wire [31:0] B,
    input wire sel,
    output reg [31:0] out
);

always @* begin
    case (sel)
    1'b0: out = immediate[10:6];
    1'b1: out = B;
    endcase
end
endmodule