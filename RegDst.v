module RegDst (
    input [4:0] instruction2016,
    input [4:0] instruction1511,
    input [4:0] reg29,
    input [4:0] reg31,
    input [1:0] sel,
    output reg out[4:0]
);

always @* begin
    case (sel)
        2'b00: out = instruction2016;
        2'b01: out = instruction1511;
        2'b10: out = reg29;
        2'b11: out = reg31;
    endcase
end
endmodule
