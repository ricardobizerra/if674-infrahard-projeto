module MemtoMDR(
    input [31:0] Mem32,
    input [31:0] Mem16,
    input [31:0] Mem8,
    input [1:0] sel,
    output reg out[31:0]
);

always @* begin
    case (sel)
    2'b00: out = Mem32;
    2'b01: out = Mem16;
    2'b10: out = Mem8;
    endcase
end
endmodule