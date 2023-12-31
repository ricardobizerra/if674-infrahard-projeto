module mux_pc_src (
    input wire [31:0] AluOutDirect,
    input wire [31:0] AluOut,
    input wire [31:0] instructionShiftLeft2,
    input wire [31:0] MemSignExtend,
    input wire [31:0] EPCOut,
    input wire [2:0] sel,
    output reg [31:0] out
);

always @* begin
    case (sel)
        3'b000: out = AluOutDirect;
        3'b001: out = AluOut;
        3'b010: out = instructionShiftLeft2;
        3'b011: out = MemSignExtend;
        3'b100: out = EPCOut;
    endcase
end
endmodule
