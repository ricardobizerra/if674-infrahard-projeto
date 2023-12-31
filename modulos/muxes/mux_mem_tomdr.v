module mux_mem_tomdr(
    input wire [31:0] Mem32,
    input wire [31:0] Mem16,
    input wire [31:0] Mem8,
    input wire [1:0] sel,
    output reg [31:0] out
);

always @* begin
    case (sel)
    2'b00: out = Mem32;
    2'b01: out = Mem16;
    2'b10: out = Mem8;
    endcase
end
endmodule