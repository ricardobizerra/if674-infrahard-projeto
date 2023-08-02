module mux_except(
    input wire [1:0] sel,
    output reg [31:0] out
);

always @* begin
    case (sel)
    2'b00: out = 32'b00000000000000000000000011111101; // 253
    2'b01: out = 32'b00000000000000000000000011111110; // 254
    2'b10: out = 32'b00000000000000000000000011111111; // 255
    endcase
end
endmodule