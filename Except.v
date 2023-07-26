module Except(
    input [1:0][31:0] in,
    input [1:0] sel,
    output reg out[31:0]
);

always @* begin
    case (sel)
    2'b00: out = 253; //in[0]
    2'b01: out = 254; //in[1]
    2'b10: out = 255; //in[2]
    endcase
end
endmodule